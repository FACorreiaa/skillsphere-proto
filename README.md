# SkillSphere Protocol Buffers

This repository contains the Protocol Buffer definitions for SkillSphere's Connect RPC API. SkillSphere is a peer-to-peer skill exchange platform that enables users to trade skills in real-time through profiles, intelligent matching algorithms, and interactive sessions.

## Overview

The API is built using [Connect RPC](https://connectrpc.com/), a modern, type-safe RPC framework that works over HTTP/1.1, HTTP/2, and HTTP/3. Connect provides excellent interoperability with gRPC while being simpler and more web-friendly.

This repository generates client and server code for:
- **Go** - Backend services
- **Kotlin** - Android/JVM clients

## Architecture

The API is organized into two tiers:

### MVP Services (Core Platform)

These services form the foundation of SkillSphere and are essential for the initial launch:

1. **UserService** (`proto/user/v1/`) - User profile management, authentication, and account operations
2. **SkillService** (`proto/skill/v1/`) - Skills catalog, user skill associations (offered/wanted), and proficiency management
3. **MatchingService** (`proto/matching/v1/`) - Skill matching algorithms (cosine similarity, distance-based), recommendations, and match scoring
4. **SessionService** (`proto/session/v1/`) - 1:1 skill exchange session scheduling, management, and lifecycle
5. **ChatService** (`proto/chat/v1/`) - Real-time messaging with WebSocket support via server streaming
6. **SearchService** (`proto/search/v1/`) - User and skill discovery with keyword search, filters, and trending skills
7. **AuthService** (`proto/auth/v1/`) - JWT-based authentication, OAuth integration, token management

### Extended Services (Advanced Features)

These services enable monetization, AI features, and platform scaling:

8. **PaymentService** (`proto/payment/v1/`) - Stripe integration for subscriptions, one-time payments, and escrow for gigs
9. **CertificationService** (`proto/certification/v1/`) - Blockchain-based badges and NFTs for verified skill achievements
10. **AIService** (`proto/ai/v1/`) - LLM-powered features: skill embeddings (Gemini), personalized roadmaps, AI mentoring
11. **WorkshopService** (`proto/workshop/v1/`) - Group sessions (1:many) with ticketing and live streaming
12. **GigService** (`proto/gig/v1/`) - Freelance marketplace for paid skill exchanges with escrow payments
13. **ChallengeService** (`proto/challenge/v1/`) - Community skill challenges with leaderboards and gamification
14. **ReviewService** (`proto/review/v1/`) - Asynchronous expert reviews of uploaded content (code, designs, etc.)
15. **AnalyticsService** (`proto/analytics/v1/`) - Platform metrics, skill trends, and user behavior insights
16. **AdminService** (`proto/admin/v1/`) - Moderation tools, content flagging, user management, and dispute resolution

## Repository Structure

```
skillsphere-proto/
├── proto/
│   ├── common/v1/           # Shared types, enums, and messages
│   ├── user/v1/             # User service
│   ├── skill/v1/            # Skill service
│   ├── matching/v1/         # Matching service
│   ├── session/v1/          # Session service
│   ├── chat/v1/             # Chat service
│   ├── search/v1/           # Search service
│   ├── auth/v1/             # Auth service
│   ├── payment/v1/          # Payment service (extended)
│   ├── certification/v1/    # Certification service (extended)
│   ├── ai/v1/               # AI service (extended)
│   ├── workshop/v1/         # Workshop service (extended)
│   ├── gig/v1/              # Gig service (extended)
│   ├── challenge/v1/        # Challenge service (extended)
│   ├── review/v1/           # Review service (extended)
│   ├── analytics/v1/        # Analytics service (extended)
│   └── admin/v1/            # Admin service (extended)
├── gen/
│   ├── go/                  # Generated Go code
│   ├── go-connect/          # Generated Connect RPC Go code
│   ├── kotlin/              # Generated Kotlin code
│   └── kotlin-connect/      # Generated Connect RPC Kotlin code
├── buf.gen.yaml             # Buf code generation config
├── buf.yaml                 # Buf module config
└── README.md
```

## Prerequisites

- [Buf CLI](https://buf.build/docs/installation) v1.28.0+
- Go 1.21+ (for Go code generation)
- Kotlin/JVM (for Kotlin code generation)

## Installation

### Install Buf

**macOS (Homebrew):**
```bash
brew install bufbuild/buf/buf
```

**Linux/macOS (Direct):**
```bash
curl -sSL "https://github.com/bufbuild/buf/releases/download/v1.28.0/buf-$(uname -s)-$(uname -m)" -o /usr/local/bin/buf
chmod +x /usr/local/bin/buf
```

**Windows:**
Download from [Buf releases](https://github.com/bufbuild/buf/releases)

### Clone Repository

```bash
git clone https://github.com/yourusername/skillsphere-proto.git
cd skillsphere-proto
```

## Usage

### Generate Code

Generate client and server code for all languages:

```bash
buf generate
```

This creates:
- `gen/go/` - Go protobuf messages
- `gen/go-connect/` - Connect RPC Go services
- `gen/kotlin/` - Kotlin protobuf messages
- `gen/kotlin-connect/` - Connect RPC Kotlin clients

### Lint Protos

Check for style and compatibility issues:

```bash
buf lint
```

### Format Protos

Auto-format proto files:

```bash
buf format -w
```

### Breaking Change Detection

Ensure backward compatibility:

```bash
buf breaking --against '.git#branch=main'
```

## Integration

### Go Backend

1. Import generated code in your Go project:

```go
import (
    userv1 "github.com/yourusername/skillsphere-proto/gen/go/user/v1"
    "github.com/yourusername/skillsphere-proto/gen/go-connect/user/v1/userv1connect"
)

// Implement service
type UserServer struct{}

func (s *UserServer) GetUser(
    ctx context.Context,
    req *connect.Request[userv1.GetUserRequest],
) (*connect.Response[userv1.GetUserResponse], error) {
    // Your implementation
}

// Register with HTTP server
mux := http.NewServeMux()
path, handler := userv1connect.NewUserServiceHandler(&UserServer{})
mux.Handle(path, handler)
```

2. Add dependency to your `go.mod`:
```bash
go get github.com/yourusername/skillsphere-proto
```

### Kotlin/Android Client

1. Add generated code to your project's source path

2. Use Connect client:

```kotlin
import build.buf.protocgen.connect.skillsphere.user.v1.UserServiceClient
import build.buf.protocgen.connect.skillsphere.user.v1.GetUserRequest

val client = UserServiceClient(
    httpClient = OkHttpClient(),
    baseUrl = "https://api.skillsphere.com"
)

val response = client.getUser(GetUserRequest(userId = "123"))
println(response.user.name)
```

## Key Features in Proto Definitions

### Common Types (`proto/common/v1/common.proto`)

- **User**: Profile with bio, location, avatar, ratings
- **Skill**: Name, category, proficiency level (1-10)
- **SkillCategory**: Tech, Languages, Creative, Professional, Hobbies, Fitness
- **Location**: City, country, timezone for matching
- **Availability**: Weekly schedule for session planning
- **ProficiencyLevel**: Beginner (1-3), Intermediate (4-7), Expert (8-10)

### Matching Algorithms (`proto/matching/v1/matching.proto`)

- **MatchingAlgorithm**: Enum for Euclidean, Cosine, Embedding-based (AI)
- **FindMatches**: Returns scored matches with explanations (e.g., "70% skill overlap")
- **GetRecommendations**: Personalized suggestions based on user history

### AI Integration (`proto/ai/v1/ai.proto`)

- **GenerateSkillEmbedding**: Create 300D vectors via Gemini for semantic matching
- **GetSkillRoadmap**: LLM-generated learning paths
- **GetAIMentorAdvice**: Contextual tips for sessions (e.g., "Focus on async/await for JS")

### Real-Time Features (`proto/chat/v1/chat.proto`)

- **StreamMessages**: Server streaming RPC for WebSocket-like chat
- **SendMessage**: Unary RPC for message sending with delivery confirmation

### Monetization (`proto/payment/v1/payment.proto`)

- **CreateSubscription**: Freemium tiers (Basic free, Premium $5-20/month)
- **CreateEscrowPayment**: Hold funds for gig completion
- **ProcessPayoutRequest**: Payout to experts after session

### Blockchain Certifications (`proto/certification/v1/certification.proto`)

- **IssueCertification**: Mint NFT badge on Polygon for completed exchanges
- **VerifyCertification**: Validate badge ownership via blockchain

## API Conventions

### Request/Response Patterns

All RPCs follow these naming conventions:

```protobuf
// Unary RPC
rpc GetUser(GetUserRequest) returns (GetUserResponse);

// Server streaming
rpc StreamMessages(StreamMessagesRequest) returns (stream StreamMessagesResponse);

// Client streaming (not commonly used)
rpc UploadContent(stream UploadContentRequest) returns (UploadContentResponse);

// Bidirectional streaming
rpc Chat(stream ChatMessage) returns (stream ChatMessage);
```

### Error Handling

Connect uses standard HTTP status codes and gRPC error codes:

- `NOT_FOUND` (404) - Resource doesn't exist
- `INVALID_ARGUMENT` (400) - Bad input
- `UNAUTHENTICATED` (401) - Invalid/missing JWT
- `PERMISSION_DENIED` (403) - Insufficient privileges
- `ALREADY_EXISTS` (409) - Duplicate resource
- `INTERNAL` (500) - Server error

Example error in Go:
```go
return nil, connect.NewError(connect.CodeNotFound, errors.New("user not found"))
```

### Pagination

List RPCs use cursor-based pagination:

```protobuf
message ListUsersRequest {
  int32 page_size = 1;   // Max 100
  string page_token = 2; // Opaque cursor
}

message ListUsersResponse {
  repeated User users = 1;
  string next_page_token = 2; // Empty if no more pages
}
```

### Field Masks

Use `google.protobuf.FieldMask` for partial updates:

```protobuf
message UpdateUserRequest {
  User user = 1;
  google.protobuf.FieldMask update_mask = 2; // e.g., "bio,avatar_url"
}
```

### Timestamps

Always use `google.protobuf.Timestamp` for dates:

```protobuf
import "google/protobuf/timestamp.proto";

message Session {
  google.protobuf.Timestamp start_time = 1;
  google.protobuf.Timestamp end_time = 2;
}
```

## Versioning Strategy

- **v1**: Initial stable release for MVP
- **v2**: Major breaking changes (e.g., new matching algorithm)
- **vX-alpha**: Experimental features (e.g., v2-alpha for AI roadmaps)

To add a new version:
1. Create `proto/servicename/v2/` directory
2. Update `go_package` option
3. Keep v1 for backward compatibility

## Development Workflow

### Adding a New RPC

1. Define message in appropriate proto file:
```protobuf
message CreateWorkshopRequest {
  string title = 1;
  int32 max_participants = 2;
}

message CreateWorkshopResponse {
  Workshop workshop = 1;
}
```

2. Add RPC to service:
```protobuf
service WorkshopService {
  rpc CreateWorkshop(CreateWorkshopRequest) returns (CreateWorkshopResponse);
}
```

3. Generate code:
```bash
buf generate
```

4. Implement in Go backend
5. Test with Connect client

### Testing

Use [buf curl](https://buf.build/docs/curl/usage) for quick testing:

```bash
buf curl --http2-prior-knowledge \
  --data '{"user_id": "123"}' \
  http://localhost:8080/skillsphere.user.v1.UserService/GetUser
```

Or with `grpcurl` for gRPC servers:

```bash
grpcurl -plaintext -d '{"user_id": "123"}' \
  localhost:8080 skillsphere.user.v1.UserService/GetUser
```

## Performance Considerations

### Streaming RPCs

- Use server streaming for long-lived connections (chat, notifications)
- Implement backpressure handling in clients
- Consider using WebSocket transport for browsers

### Batching

For high-throughput operations, use batch RPCs:

```protobuf
rpc BatchGetUsers(BatchGetUsersRequest) returns (BatchGetUsersResponse);

message BatchGetUsersRequest {
  repeated string user_ids = 1; // Max 100
}
```

### Caching

- Cache frequently accessed data (trending skills, user profiles)
- Use ETags in HTTP headers for conditional requests
- Invalidate caches on writes

## Security

### Authentication

All RPCs (except `AuthService.Login`) require JWT in headers:

```
Authorization: Bearer <jwt-token>
```

Validate tokens in Go middleware:

```go
func authMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        token := r.Header.Get("Authorization")
        // Validate JWT
        next.ServeHTTP(w, r)
    })
}
```

### Rate Limiting

- Implement per-user rate limits (e.g., 100 req/min)
- Use Redis for distributed rate limiting
- Return `RESOURCE_EXHAUSTED` (429) when exceeded

### Input Validation

- Validate all inputs server-side (don't trust clients)
- Use proto field constraints (e.g., `[(validate.rules).string.min_len = 1]`)
- Sanitize user-generated content (XSS prevention)

## Deployment

### Buf Schema Registry (BSR)

Push protos to BSR for centralized management:

```bash
buf push
```

Clients can then generate code directly:

```bash
buf generate buf.build/yourusername/skillsphere
```

### CI/CD Integration

Example GitHub Actions workflow:

```yaml
name: Proto CI
on: [push]
jobs:
  lint-and-generate:
    runs-on: ubuntu-latest
    steps:
      - uses: bufbuild/buf-setup-action@v1
      - run: buf lint
      - run: buf breaking --against '.git#branch=main'
      - run: buf generate
      - uses: actions/upload-artifact@v3
        with:
          name: generated-code
          path: gen/
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-rpc`)
3. Add/modify proto files
4. Run `buf lint` and `buf format -w`
5. Ensure `buf breaking` passes
6. Commit changes (`git commit -am 'Add new RPC'`)
7. Push to branch (`git push origin feature/new-rpc`)
8. Open a Pull Request

### Proto Style Guide

- Use `snake_case` for field names
- Use `PascalCase` for message/service names
- Add comments for all public RPCs and messages
- Group related fields with blank lines
- Keep messages focused (single responsibility)

## Resources

- [Connect RPC Docs](https://connectrpc.com/docs/introduction)
- [Buf Documentation](https://buf.build/docs)
- [Protocol Buffers Guide](https://protobuf.dev/programming-guides/proto3/)
- [SkillSphere Main Repo](https://github.com/yourusername/skillsphere)

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Support

- Issues: [GitHub Issues](https://github.com/yourusername/skillsphere-proto/issues)
- Discussions: [GitHub Discussions](https://github.com/yourusername/skillsphere-proto/discussions)
- Email: proto@skillsphere.com

---

**Note**: This is a living document. As SkillSphere evolves, this README and the proto definitions will be updated to reflect new features and best practices
