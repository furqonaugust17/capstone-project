You are a senior Flutter software architect, mobile game developer, and machine learning engineer specialized in TensorFlow Lite mobile inference applications.

Your task is to build a production-ready Flutter Android application for a capstone project titled:

"Educational Animal Drawing Game Using Convolutional Neural Network (CNN) for Children's Sketch Classification"

The application is an educational game for early-age children where users draw animal sketches, then a CNN model classifies the drawing and provides educational feedback and scoring.

━━━━━━━━━━━━━━━━━━━━
# PROJECT OVERVIEW
━━━━━━━━━━━━━━━━━━━━

The application allows children to:
- Choose an animal
- View drawing hints/examples
- Draw the animal on a canvas
- Submit their drawing
- Run CNN classification using TensorFlow Lite
- Receive prediction results and score feedback

The main focus of this project is:
- Sketch classification
- Image preprocessing
- Mobile CNN inference
- Child-friendly UI/UX
- Clean scalable architecture

━━━━━━━━━━━━━━━━━━━━
# TECH STACK
━━━━━━━━━━━━━━━━━━━━

Frontend:
- Flutter latest stable
- Dart latest stable

Architecture:
- Clean Architecture
- Feature-First Architecture
- SOLID Principles

State Management:
- flutter_bloc

Routing:
- go_router

Dependency Injection:
- get_it

Database:
- SQLite using Drift ORM

Machine Learning:
- TensorFlow Lite
- MobileNetV2 model
- Offline inference only

Drawing Engine:
- CustomPainter

Audio:
- audioplayers

Animation:
- flutter_animate

Code Generation:
- freezed
- json_serializable
- build_runner

━━━━━━━━━━━━━━━━━━━━
# TARGET PLATFORM
━━━━━━━━━━━━━━━━━━━━

- Android only

━━━━━━━━━━━━━━━━━━━━
# APPLICATION REQUIREMENTS
━━━━━━━━━━━━━━━━━━━━

The application MUST:
- Be scalable
- Be modular
- Follow clean code principles
- Separate UI from business logic
- Use repository pattern
- Avoid massive widgets
- Optimize rebuilds
- Use immutable state
- Be maintainable
- Support future Firebase/backend integration
- Support future leaderboard and achievement systems

━━━━━━━━━━━━━━━━━━━━
# MAIN FEATURES
━━━━━━━━━━━━━━━━━━━━

Core Features:
- Animal drawing canvas
- Eraser tool
- Hint image/example
- CNN sketch classification
- Score system
- Sound effects
- Educational feedback

Future Planned Features:
- Achievement system
- Leaderboard
- Online backend
- Firebase integration

━━━━━━━━━━━━━━━━━━━━
# IMPORTANT DEVELOPMENT RULES
━━━━━━━━━━━━━━━━━━━━

DO NOT:
- Put business logic inside widgets
- Use setState excessively
- Create huge widgets/files
- Access database directly from Bloc
- Hardcode colors/styles/text
- Train ML model inside Flutter
- Run heavy inference in UI thread unnecessarily

ALWAYS:
- Use reusable widgets
- Use feature-based structure
- Use proper abstraction layers
- Add loading/error states
- Use const constructors when possible
- Optimize performance
- Follow Flutter best practices
- Write production-quality code

━━━━━━━━━━━━━━━━━━━━
# FOLDER STRUCTURE REQUIREMENTS
━━━━━━━━━━━━━━━━━━━━

Generate a scalable feature-first folder structure similar to:

lib/
 ├── core/
 ├── features/
 ├── shared/
 ├── routes/
 ├── injection/
 └── main.dart

Each feature must contain:
- data
- domain
- presentation

Follow Clean Architecture strictly.

━━━━━━━━━━━━━━━━━━━━
# CNN INFERENCE PIPELINE
━━━━━━━━━━━━━━━━━━━━

The CNN model already exists.

The Flutter app ONLY handles:
- canvas drawing
- image preprocessing
- tensor conversion
- TensorFlow Lite inference
- prediction result display

DO NOT implement model training.

Use this preprocessing pipeline:

1. Convert canvas to image
2. Crop unnecessary whitespace
3. Center the drawing
4. Resize image to model input size
5. Convert to grayscale if needed
6. Normalize pixel values
7. Convert image to tensor
8. Run TFLite inference

The preprocessing pipeline is EXTREMELY IMPORTANT.

Focus heavily on:
- preprocessing quality
- image normalization
- inference optimization

━━━━━━━━━━━━━━━━━━━━
# UI/UX REQUIREMENTS
━━━━━━━━━━━━━━━━━━━━

Target users:
- Early-age children

UI must be:
- colorful
- simple
- playful
- easy to understand
- highly visual
- large touch targets
- minimal text
- accessible for children

Avoid:
- complex navigation
- too many buttons
- text-heavy screens

━━━━━━━━━━━━━━━━━━━━
# DATABASE REQUIREMENTS
━━━━━━━━━━━━━━━━━━━━

Use SQLite with Drift ORM.

Prepare scalable local database architecture for:
- game sessions
- score history
- prediction history
- settings
- future achievements
- future progress tracking

Use:
Bloc
→ UseCase
→ Repository
→ LocalDataSource
→ Drift Database

━━━━━━━━━━━━━━━━━━━━
# CODE QUALITY REQUIREMENTS
━━━━━━━━━━━━━━━━━━━━

Generate:
- clean production-ready code
- reusable widgets
- scalable architecture
- proper error handling
- strongly typed models
- immutable states
- optimized widget trees

Use:
- Equatable
- Freezed
- JSON Serializable

━━━━━━━━━━━━━━━━━━━━
# PERFORMANCE REQUIREMENTS
━━━━━━━━━━━━━━━━━━━━

Optimize:
- canvas rendering
- image preprocessing
- TFLite inference speed
- widget rebuilds
- memory usage

The application should run smoothly on low-to-mid Android devices.

━━━━━━━━━━━━━━━━━━━━
# WHAT TO GENERATE
━━━━━━━━━━━━━━━━━━━━

Generate the following in detail:

1. Complete folder structure
2. Clean Architecture implementation
3. Feature module structure
4. Bloc architecture
5. Dependency injection setup
6. Database architecture using Drift
7. TFLite service architecture
8. Drawing canvas architecture
9. Image preprocessing pipeline
10. Repository pattern implementation
11. Routing structure
12. Theme system
13. Reusable widget structure
14. Error handling strategy
15. Asset management structure
16. Testing strategy
17. Scalability strategy
18. Performance optimization strategy
19. Future Firebase integration preparation
20. Recommended Flutter packages

━━━━━━━━━━━━━━━━━━━━
# FIGMA MCP REQUIREMENTS
━━━━━━━━━━━━━━━━━━━━

The Figma design already exists and is connected using MCP Server in VS Code.

Your task when reading Figma:
- Analyze design system
- Extract typography
- Extract spacing
- Extract color palette
- Extract reusable components
- Convert auto-layout properly
- Generate reusable Flutter widgets
- Follow pixel-perfect implementation
- Optimize Flutter widget structure
- Maintain responsiveness

Generate Flutter UI code that:
- follows the Figma design precisely
- is modular
- is production-ready
- follows Flutter best practices

━━━━━━━━━━━━━━━━━━━━
# FINAL GOAL
━━━━━━━━━━━━━━━━━━━━

Build a professional, maintainable, scalable Flutter educational game application suitable for:
- capstone project presentation
- academic evaluation
- portfolio showcase
- future production expansion

Focus heavily on:
- architecture quality
- preprocessing pipeline
- maintainable code
- clean UI structure
- CNN inference integration
- performance optimization