# macOS mouse input

The macOS runner can receive a mouse down and up between input samples without
exposing either through `mouse_check_button_pressed/released`. GMmacOSTools now
keeps these native events in a window-local queue. It observes and returns AppKit
events unchanged; it does not move the system pointer or synthesize input.

`scripts/mouse_input/mouse_input.gml` is the shared input adapter. The controller's
Begin Step polls once, and all Step/Draw consumers read that same snapshot.
Windows and other platforms delegate to the original GameMaker functions.

- Each press or release is exposed for a complete frame, preserving rapid clicks
  and the press origin used by NBS's release-inside-control checks.
- Consecutive motion events are coalesced. A final drag position gets a held frame
  before release, so a short automated drag can still move the control.
- Coordinates come from the event, normalized to the native content view and
  mapped through NBS's current camera. They do not depend on the physical pointer.
- Focus loss, native menus/sheets, resizing, overflow, and stale queued input cancel
  held state without inventing a release that could activate a button.
- Existing `mouse_clear`/`io_clear` sites clear the adapter too. Native text input
  and the existing scroll implementation continue to use their existing paths.

This bridge intentionally introduces up to one frame per queued button transition
to match the current UI's polling model. It is not a general keyboard event replay
system: modifier keys and text remain on GameMaker's existing input path.

## Rebuild the extension

The source is maintained in the sibling `GMmacOSTools` repository:

- `GMmacOSTools/MouseInput.mm`: AppKit observer and extension exports.
- `GMmacOSTools/MouseInputQueue.hpp`: queue-to-frame reducer.
- `tests/MouseInputQueueTests.cpp`: rapid clicks, drag ordering, button independence,
  cancellation, clearing, overflow, motion coalescing, and stale-input tests.

Run `bash tools/build_mouse_input.sh` there, then copy the printed
`libGMmacOSTools.dylib` into this directory. The script builds and checks the tests,
produces arm64/x86_64 slices with a macOS 12 minimum, and signs the local library
ad hoc. It selects `/Applications/Xcode.app` unless `DEVELOPER_DIR` is overridden.
Normal release packaging must still sign the app and embedded libraries with the
project's distribution identity.

The added exports are `gm_mouse_start`, `gm_mouse_poll`, `gm_mouse_clear`, and
`gm_mouse_stop`, registered as `macos_mouse_*` in the extension metadata.
