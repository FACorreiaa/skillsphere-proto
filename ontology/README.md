# SkillSphere Ontology

This directory contains the SkillSphere ontology assets that mirror the semantics encoded in the proto definitions. Everything is authored in RDF/Turtle so it can be loaded into any triple store (Blazegraph, Jena/Fuseki, Neptune, pg_rdf, etc.) or reasoned on locally with tools such as `riot`, `rdflib`, or `jena`.

## Files

| File | Description |
| --- | --- |
| `skillsphere.ttl` | Hand-authored OWL + SKOS vocabulary for users, skills, sessions, matching metadata, recommendations, and relationships derived from the MVP protos. |
| `generated.ttl` | Auto-generated SKOS concept schemes built from the Buf descriptors (enums, tiers, algorithm types, etc.). |
| `shapes.ttl` | SHACL node/property shapes that validate key domain rules (participants per session, proficiency range, embeddings). |

## Proto ↔ Ontology Mapping

| Proto Definition | Ontology Concept | Notes |
| --- | --- | --- |
| `skillsphere.common.v1.User` | `sk:User` (subclass of `foaf:Person`) | Captures bios, availability, subscription tier, and skill associations through dedicated properties. |
| `skillsphere.common.v1.Skill` | `sk:Skill` (subclass of `schema:Intangible` + `skos:Concept`) | Categorized using the SKOS concept scheme defined in `generated.ttl`. |
| `skillsphere.common.v1.UserSkill` | `sk:SkillAssociation` | Includes proficiency value, category, offered/wanted intent, and narrative text. |
| `skillsphere.session.v1.Session` | `sk:Session` (subclass of `schema:Event`) | Links initiator/partner, scheduled windows, and premium metadata. |
| `skillsphere.matching.v1.Match` | `sk:Match` + `sk:SkillMatch` | Stores algorithm provenance, per-skill explanations, and scores. |
| `skillsphere.matching.v1.Recommendation` | `sk:Recommendation` | Uses properties for relevance score, textual reason, and the recommended entity. |
| `skillsphere.common.v1.Rating` | `sk:Rating` (subclass of `schema:Review`) | Aligns the 1-5 rating scale with schema.org semantics. |
| Enums (`SkillCategory`, `ProficiencyLevel`, `SessionStatus`, etc.) | Generated SKOS concept schemes | Keeps Buf enums, the ontology, and downstream clients in sync. |

## Generator Workflow

The `ontology/cmd/generate` tool reads the current Buf descriptor set and emits `generated.ttl` so enum instances never drift from the proto source of truth.

```bash
# From the repository root (ensure Buf + Go installed)
GOFLAGS=-mod=mod GOCACHE=/tmp/skillsphere-gocache go run ./ontology/cmd/generate \
  --module-path=. \
  --out=/tmp/generated.ttl
mv /tmp/generated.ttl ontology/generated.ttl
```

- Omit the `GOFLAGS` override if you prefer vendor mode. The custom `GOCACHE` keeps Go from writing into protected directories inside the harness.
- Regenerate `generated.ttl` whenever a proto enum changes, then commit the updated file with the proto change.

## SHACL Validation

Run the SHACL shapes to catch modeling errors before data fuels search/matching pipelines:

```bash
riot --validate ontology/skillsphere.ttl ontology/generated.ttl ontology/shapes.ttl
shacl validate --data path/to/exported_graph.ttl --shapes ontology/shapes.ttl
```

The shapes enforce constraints such as:
- `SkillAssociation` proficiency values must sit between 1–10 and reference a declared `ProficiencyLevel` concept.
- Sessions must reference exactly two participants, capture status + schedule, and optionally share a meeting URL.
- Matches never leave `matchScore` outside `[0,1]` and must name the algorithm used.
- Embeddings must point to either a skill or a user and declare their model version.

## Extension Guidelines

- Mirror proto changes in the ontology as part of the same PR to avoid schema drift (proto update → regenerate TTL → update SHACL if needed).
- Reuse external vocabularies whenever one already exists (schema.org for events, FOAF for people, SKOS for enumerations, GeoSPARQL for advanced location handling).
- Keep breaking changes versioned through the ontology header (`owl:versionInfo`) and tag releases when publishing to a triple store or public registry.
- Future automation: extend the generator to emit additional structures (e.g., SHACL skeletons, JSON-LD contexts) directly from Buf descriptors.

