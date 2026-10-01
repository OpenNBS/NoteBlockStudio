// One snapshot is shared by every Step and Draw consumer in a frame.
global.nbs_mouse_state = {ready:false, valid:false, x:0, y:0,
    held:0, pressed:0, released:0, cancelled:false}
global.nbs_mouse_retry = 0

function nbs_mouse_init() {
    if (os_type == os_macosx) macos_mouse_start()
}

function nbs_mouse_forget_press() {
    if (instance_exists(obj_controller)) {
        obj_controller.mousepress_x = -1
        obj_controller.mousepress_y = -1
        obj_controller.mousepress_window = -1
        obj_controller.mousepress_layericon = -1
        obj_controller.w_isdragging = 0
        obj_controller.aa = 0
        obj_controller.draggingtab = -1
        obj_controller.tabdrag = 0
    }
}

function nbs_mouse_step() {
    if (os_type != os_macosx) return;
    global.nbs_mouse_state = json_parse(macos_mouse_poll())
    if (global.nbs_mouse_state.cancelled) nbs_mouse_forget_press()
    // Window creation can finish after extension initialization. Until ready,
    // consumers retain the runner's normal mouse behavior.
    if (!global.nbs_mouse_state.ready) {
        global.nbs_mouse_retry++
        if (global.nbs_mouse_retry >= 60) {
            global.nbs_mouse_retry = 0
            macos_mouse_start()
        }
    } else global.nbs_mouse_retry = 0
}

function nbs_mouse_x() {
    var state = global.nbs_mouse_state
    if (os_type != os_macosx || !state.ready || !state.valid) return mouse_x
    var camera = obj_controller.cam_window
    return camera_get_view_x(camera) + state.x * camera_get_view_width(camera)
}

function nbs_mouse_y() {
    var state = global.nbs_mouse_state
    if (os_type != os_macosx || !state.ready || !state.valid) return mouse_y
    var camera = obj_controller.cam_window
    return camera_get_view_y(camera) + state.y * camera_get_view_height(camera)
}

function nbs_mouse_check_button(button) {
    if (os_type != os_macosx || !global.nbs_mouse_state.ready || button < mb_left || button > mb_middle)
        return mouse_check_button(button)
    return (global.nbs_mouse_state.held & (1 << (button - 1))) != 0
}

function nbs_mouse_check_button_pressed(button) {
    if (os_type != os_macosx || !global.nbs_mouse_state.ready || button < mb_left || button > mb_middle)
        return mouse_check_button_pressed(button)
    return (global.nbs_mouse_state.pressed & (1 << (button - 1))) != 0
}

function nbs_mouse_check_button_released(button) {
    if (os_type != os_macosx || !global.nbs_mouse_state.ready || button < mb_left || button > mb_middle)
        return mouse_check_button_released(button)
    return (global.nbs_mouse_state.released & (1 << (button - 1))) != 0
}

function nbs_mouse_clear(button) {
    mouse_clear(button)
    if (os_type != os_macosx) return;
    var mask = (button == mb_any ? 7 : (button >= mb_left && button <= mb_middle ? 1 << (button - 1) : 0))
    macos_mouse_clear(mask)
    global.nbs_mouse_state.held &= ~mask
    global.nbs_mouse_state.pressed &= ~mask
    global.nbs_mouse_state.released &= ~mask
    if (mask & 1) nbs_mouse_forget_press()
}

function nbs_io_clear() {
    io_clear()
    if (os_type == os_macosx) nbs_mouse_clear(mb_any)
}

function nbs_mouse_shutdown() {
    if (os_type == os_macosx) macos_mouse_stop()
}
