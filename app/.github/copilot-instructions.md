# Copilot Instructions

## Project Overview

This project is an educational mobile game for early-age children titled:

"Educational Animal Drawing Game Using Convolutional Neural Network (CNN) for Children's Sketch Classification"

The application allows children to:
- choose animals
- draw sketches
- submit drawings
- classify sketches using TensorFlow Lite
- receive educational feedback and score

The main focus of this project is:
- image preprocessing
- CNN sketch classification
- clean architecture
- maintainable Flutter code
- child-friendly UI/UX

---

# Technology Stack

## Frontend
- Flutter
- Dart

## Architecture
- Clean Architecture
- Feature-First Architecture
- SOLID Principles

## State Management
- flutter_bloc

## Routing
- go_router

## Dependency Injection
- get_it

## Database
- SQLite
- Drift ORM

## Machine Learning
- TensorFlow Lite
- MobileNetV2

## Drawing Engine
- CustomPainter

## Animation
- flutter_animate

## Audio
- audioplayers

---

# Architecture Rules

Always follow Clean Architecture strictly.

Each feature must contain:
- data
- domain
- presentation

Example:

lib/features/drawing/
- data/
- domain/
- presentation/

Never mix layers.

---

# Clean Architecture Rules

Follow this flow strictly:

UI
→ Bloc
→ UseCase
→ Repository
→ DataSource
→ Database / ML Service

Never:
- access database directly from Bloc
- access TensorFlow Lite directly from UI
- place business logic inside widgets

---

# State Management Rules

Use Bloc for all business logic and state management.

Rules:
- Use Cubit for simple state
- Use Bloc for complex event-driven logic
- Keep states immutable
- Use Equatable
- Avoid unnecessary rebuilds

Do not:
- use setState for business logic
- place logic inside build methods

---

# Folder Structure Rules

Use feature-first structure.

Example:

lib/
├── core/
├── features/
├── shared/
├── routes/
├── injection/
└── main.dart

Core contains:
- constants
- theme
- errors
- utils
- services
- database
- ml
- widgets

---

# UI Rules

The application targets early-age children.

UI must be:
- colorful
- playful
- simple
- highly visual
- easy to understand

Avoid:
- complex layouts
- text-heavy screens
- small buttons
- difficult navigation

Use:
- large touch targets
- rounded corners
- clear spacing
- simple interactions

---

# Flutter Best Practices

Always:
- use const constructors when possible
- split widgets into small reusable components
- optimize widget rebuilds
- prefer StatelessWidget
- use proper naming conventions
- keep files modular

Avoid:
- massive widgets
- deeply nested widget trees
- duplicated UI code
- hardcoded values

---

# Performance Rules

The application must run smoothly on low-to-mid Android devices.

Optimize:
- canvas rendering
- widget rebuilds
- image preprocessing
- TensorFlow Lite inference
- memory usage

Avoid unnecessary allocations.

Use RepaintBoundary when necessary.

---

# Drawing Canvas Rules

The drawing feature is a critical feature.

Requirements:
- use CustomPainter
- support smooth drawing
- support eraser tool
- maintain responsive performance

Keep drawing logic separated from UI.

Do not place drawing calculations directly inside widgets.

---

# TensorFlow Lite Rules

The application ONLY performs:
- image preprocessing
- tensor conversion
- TensorFlow Lite inference

Never:
- train model in Flutter
- retrain model on-device

The TensorFlow Lite model already exists.

---

# CRITICAL PREPROCESSING RULES

The preprocessing pipeline is EXTREMELY IMPORTANT.

Do not skip preprocessing before inference.

Always follow this pipeline:

1. Convert canvas to image
2. Crop unnecessary whitespace
3. Center the drawing
4. Resize image to model input size
5. Convert image to grayscale if needed
6. Normalize pixel values
7. Convert image to tensor
8. Run TensorFlow Lite inference

Poor preprocessing will significantly reduce model accuracy.

Focus heavily on:
- normalization
- centering
- image quality
- preprocessing consistency

---

# Machine Learning Rules

TensorFlow Lite inference must be separated properly.

Use this flow:

UI
→ Bloc
→ UseCase
→ Repository
→ ML Service
→ TensorFlow Lite

Never run inference directly inside widgets.

Keep ML logic modular and testable.

---

# Database Rules

Use:
- SQLite
- Drift ORM

Do not use raw SQL directly unless necessary.

Prepare scalable architecture for:
- game sessions
- prediction history
- score history
- settings
- future achievements
- future leaderboard

Never access database directly from UI or Bloc.

Use:
Bloc
→ UseCase
→ Repository
→ LocalDataSource
→ Drift Database

---

# Error Handling Rules

Always:
- handle loading states
- handle error states
- use proper exception handling
- provide fallback UI

Do not:
- swallow exceptions silently
- leave async operations unhandled

---

# Asset Management Rules

Organize assets properly.

Example:

assets/
├── images/
├── icons/
├── audio/
├── animations/
├── models/

TensorFlow Lite models must be stored inside:
assets/models/

---

# Naming Conventions

Use consistent naming conventions.

Examples:

Classes:
- DrawingBloc
- ClassifySketchUseCase

Files:
- drawing_bloc.dart
- classify_sketch_usecase.dart

Widgets:
- drawing_canvas.dart
- score_card.dart

Avoid unclear abbreviations.

---

# Code Generation Rules

Use:
- freezed
- json_serializable
- build_runner

Generate immutable models whenever possible.

---

# Figma MCP Rules

The Figma design is connected using MCP Server in VS Code.

When generating Flutter UI:
- follow Figma design exactly
- extract reusable components
- preserve spacing consistency
- preserve typography consistency
- preserve color consistency
- optimize widget structure

Always:
- create reusable widgets
- avoid duplicated layouts
- use design system constants

---

# Scalability Rules

The project may later include:
- Firebase
- backend API
- leaderboard
- achievements
- progress tracking
- authentication

Write code that is scalable and modular.

Avoid tightly coupled architecture.

---

# Testing Rules

Prefer testable architecture.

Write code that supports:
- unit testing
- bloc testing
- repository testing

Keep business logic independent from UI.

---

# Important Reminder

This project's most critical component is:

IMAGE PREPROCESSING BEFORE CNN INFERENCE

Prioritize:
- preprocessing quality
- architecture quality
- maintainability
- modular structure
- performance optimization

Do not prioritize visual complexity over code quality and inference reliability.