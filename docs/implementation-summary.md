# Implementation & Debug Summary

**Overview**
- Purpose: Implement a production-ready TensorFlow Lite inference pipeline for sketch classification following the project's Clean Architecture rules.
- Status: Core ML service, preprocessing, shaped tensor conversion, DI wiring, drawing capture (raw RGBA and PNG paths), and classification plumbing implemented. Added debug logging and utilities to repro and diagnose issues.

**High-level changes**
- Added robust preprocessing pipeline with two input flows:
  - Raw RGBA path (fast): avoids PNG round-trip and processes UI byte buffers directly.
  - PNG / decode path (compat): decodes PNG bytes to pixels, crops, centers, resizes, and optionally grayscales.
- Implemented shape-aware input conversion and fixes for typed buffers required by tflite.
- Added GitHub-style signature capture + preprocess + predict helper.
- Extensive logging and fallback logic added to detect and handle raw-RGBA inputs when PNG decoding fails.

**Files added / updated**
- **Core ML & preprocessing**
  - [lib/core/ml/image_preprocessor.dart](lib/core/ml/image_preprocessor.dart) — image decoding, crop/center/resize, raw-RGBA preprocessing; added debug logs for incoming sizes.
  - [lib/core/ml/tflite_service.dart](lib/core/ml/tflite_service.dart) — interpreter wrapper, input/output shape helpers, inference runner.
  - [lib/core/ml/tensor_converter.dart](lib/core/ml/tensor_converter.dart) — converts `package:image` images to normalized `Float32List` and produces interpreter input shape (now returns proper 4-D nested structure or flat buffer as appropriate).

- **Classification feature**
  - [lib/features/classification/data/datasources/tflite_local_data_source.dart](lib/features/classification/data/datasources/tflite_local_data_source.dart) — supports `isRawRgba`, `width`, `height` params; auto-detects raw RGBA by length; falls back from PNG decode to inferred-RGBA; added debug prints.
  - [lib/features/classification/data/repositories/classification_repository_impl.dart](lib/features/classification/data/repositories/classification_repository_impl.dart) — forwarded RGBA params through repository.
  - [lib/features/classification/domain/repositories/classification_repository.dart](lib/features/classification/domain/repositories/classification_repository.dart) — repository contract extended to accept raw-RGBA params.
  - [lib/features/classification/presentation/bloc/classification_event.dart](lib/features/classification/presentation/bloc/classification_event.dart) — `ClassificationRequested` extended with `isRawRgba`, `width`, `height`.
  - [lib/features/classification/presentation/bloc/classification_bloc.dart](lib/features/classification/presentation/bloc/classification_bloc.dart) — forwards RGBA metadata from the event to the usecase.

- **Drawing / UI**
  - [lib/features/drawing/presentation/pages/drawing_page.dart](lib/features/drawing/presentation/pages/drawing_page.dart) — switched capture from PNG to raw RGBA capture (`ui.ImageByteFormat.rawRgba`) and dispatches `ClassificationRequested(imageBytes, isRawRgba: true, width, height)`.
  - [lib/features/drawing/presentation/utils/signature_prediction_helper.dart](lib/features/drawing/presentation/utils/signature_prediction_helper.dart) — helper implementing the GitHub-style flow: capture -> decode -> resize -> grayscale -> prediction utilities (both grayscale bytes and direct predict helper).

**Debugging changes**
- Added debug prints at these key points:
  - `ImagePreprocessor.decodeImage`: logs `incoming bytes` length.
  - `ImagePreprocessor.preprocessFromRgba`: logs `rgbaBytes` length and provided width/height.
  - `TFLiteLocalDataSource.classifySketch`: logs incoming `imageBytes.length`, `srcWidth`, `srcHeight`, model input dims and which preprocessing path was chosen; logs PNG-decode failure and RGBA fallback inference.

**Known current runtime issue and root cause analysis**
- Observed error(s) during testing:
  - Initially: PNG decode failed because bytes came from raw RGBA captured via `toByteData(format: rawRgba)` (PNG decode expects PNG-encoded bytes).
  - Later: "type 'List<double>' is not a subtype of type 'Float32List'" when passing shaped inputs — resolved by returning `Float32List` buffers.
  - Latest: `tflite/kernels/conv.cc:345 input->dims->size != 4 (1 != 4)` indicating the interpreter received a tensor with rank 1 where it expected rank 4. This required sending a nested 4-D structure (batch,H,W,C) where the deepest elements are `Float32List`. The code now conditionally builds that nested structure when the model input shape is rank 4.

**Sample debug output captured**
- PNG-decode failure (raw RGBA sent as PNG):

```
I/flutter ( 3952): TFLiteLocalDataSource.classifySketch: imageBytes=4858992, srcWidth=null, srcHeight=null, modelWxH=224x224, isRawRgba=false
I/flutter ( 3952): ImagePreprocessor.decodeImage: incoming bytes=4858992
I/flutter ( 3952): TFLiteLocalDataSource: PNG decode failed: ImagePreprocessorException(message: Invalid image input. Could not decode image bytes., cause: null)
```

- Successful detection of raw-RGBA path (example output after fixes):

```
I/flutter ( 3952): TFLiteLocalDataSource: using preprocessFromRgba (likely raw RGBA)
I/flutter ( 3952): ImagePreprocessor.preprocessFromRgba: rgbaBytes=4858992, width=823, height=1476
I/flutter ( 3952): TFLiteLocalDataSource.classifySketch: imageBytes=4858992, srcWidth=823, srcHeight=1476, modelWxH=224x224, isRawRgba=true
```

**How to reproduce locally**
1. Run the app on device/emulator:

```bash
flutter run
```

2. Open the drawing page, draw, then press the classify button (the floating action button) to dispatch classification.

3. Inspect the console logs for the debug lines above. For filtered logs:

```bash
flutter logs | grep -E "ImagePreprocessor|TFLiteLocalDataSource|ClassificationException"
```

**How to use the new helpers**
- High-level single-call predict (captures signature pad and runs inference):

```dart
final scores = await SignaturePredictionHelper.predictFromSignature(signatureGlobalKey);
```

- Two-step (inspect intermediate grayscale bytes):

```dart
final bytes = await SignaturePredictionHelper.preprocessSignatureToGrayscaleBytes(signatureGlobalKey);
final scores = await SignaturePredictionHelper.predictFromGrayscaleBytes(bytes);
```

- Fast raw-RGBA path (already wired): `DrawingPage` now captures raw RGBA and emits an event with `isRawRgba=true` and width/height. This avoids PNG encode/decode cost.

**Next recommended steps**
- Run end-to-end inference on a device and paste the console output here if errors persist (include the debug lines).
- Replace `print` debug statements with a proper logging mechanism (e.g., `logger` package) and gate them behind a debug flag.
- Add unit tests for:
  - `ImagePreprocessor.preprocessFromRgba` with synthetic RGBA buffers.
  - `TensorConverter.toInterpreterInputForShape` for several input shapes (2D, 3D, 4D).
- Measure inference latency and optimize `pixelRatio` used when capturing the canvas.

**Notes**
- The implementation preserves the project's Clean Architecture flow: UI → Bloc → UseCase → Repository → DataSource → ML Service.
- All changes were kept minimal and focused to avoid unrelated regressions.

If you want, I can now:
- Remove or toggle debug prints and add a logger.
- Add end-to-end integration tests or a small debug screen showing intermediate images (cropped/centered/28x28 preview).

---
*Generated by the assistant during an interactive debugging session.*

## Problems Encountered — Resolved and Remaining

Below is a concise log of the runtime and integration problems we encountered during implementation, what was done to resolve them, and what remains to verify.

- PNG decode failure when sending raw RGBA bytes
  - Symptom: `ImagePreprocessorException(message: Invalid image input. Could not decode image bytes.)` right after calling decodeImage.
  - Cause: UI code captured raw RGBA (via `ui.Image.toByteData(format: rawRgba)`), but the code attempted to decode those bytes as a PNG image.
  - Fix implemented: Added raw-RGBA preprocessing path (`preprocessFromRgba`) and updated the drawing page to dispatch `ClassificationRequested(..., isRawRgba: true, width: w, height: h)`. Added fallback that detects RGBA by byte-length and retries preprocessing when PNG decode fails.

- Buffer type mismatch (List<double> vs Float32List)
  - Symptom: runtime error `type 'List<double>' is not a subtype of type 'Float32List'` during interpreter.run.
  - Cause: Some code paths constructed generic `List<double>` or nested lists for inputs instead of `Float32List` for the leaf numeric buffers required by tflite.
  - Fix implemented: Ensured all flat numeric buffers are `Float32List` (used `Float32List` consistently). Updated `TensorConverter.toInterpreterInputForShape` to initially return a flat `Float32List` and then later to build typed nested structures where necessary.

- Interpreter input rank/shape mismatch (Conv kernel prepare failure)
  - Symptom: tflite error: `tflite/kernels/conv.cc:345 input->dims->size != 4 (1 != 4)` and `Node number XXX (CONV_2D) failed to prepare.`
  - Cause: The interpreter received a rank-1 (flat) tensor where the model expected a 4-D tensor `[batch, H, W, C]` (or similar), or the nested structure's layout didn't match the model's expected layout.
  - Mitigations implemented: Added a shape-aware conversion that will build a nested 4-D list where the deepest elements are `Float32List` slices for channels when the model input shape is rank 4. This mirrors how the output buffer is constructed and satisfies the interpreter's expected types.
  - Next verification: This fix requires runtime verification on device/emulator since the interpreter's native expectations can be strict. If the error persists, we'll capture the exact `inputShape` returned by the interpreter and compare it against the built input (we can add a debug log in `TFLiteService.init()` to print `inputShape`/`outputShape`).

- Channel inference and grayscale handling
  - Symptom: Incorrect channel count or unexpected input tensor lengths (e.g., huge flattened lengths interpreted as channels).
  - Cause: Model input shapes can be given in different formats (flattened vs NHWC). The code previously assumed channel count in various places without consulting the interpreter shape.
  - Fix implemented: `_resolveImageChannels` inspects the model inputShape and attempts to infer channels reliably (handles common ranks). The preprocessing flow supports both RGB and single-channel grayscale paths and exposes `forceGrayscale` override.

If you hit any of these errors again, please paste the console output including:
- The debug lines printed by `TFLiteLocalDataSource.classifySketch` (imageBytes length, `srcWidth`, `srcHeight`, model input dims, `isRawRgba`).
- Any tflite native errors (the Node/conv prepare logs) and the model `inputShape` / `outputShape` printed (I can add that logging to `TFLiteService.init()` on request).

Would you like me to add a debug log in `TFLiteService.init()` that prints `inputShape` and `outputShape` on startup? This will make it much easier to verify the exact tensor signature the model expects at runtime.
