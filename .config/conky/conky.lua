-- This is a lua script for use in Conky.
require 'cairo'

function conky_main ()
    if conky_window == nil then
        return
    end
    local cs = cairo_xlib_surface_create (conky_window.display,
                                         conky_window.drawable,
                                         conky_window.visual,
                                         conky_window.width,
                                         conky_window.height)
    cr = cairo_create (cs)

    draw_line ()

    cairo_destroy (cr)
    cairo_surface_destroy (cs)
    cr = nil
end

function draw_line ()
    local red, green, blue, alpha = 1, 1, 1, 1
    local startx = 100
    local starty = 140
    local endx = 600 - startx
    local endy = starty

    cairo_set_line_width (cr, 10)
    cairo_set_line_cap  (cr, CAIRO_LINE_CAP_BUTT)
    cairo_set_source_rgba (cr, red, green, blue, alpha)
    cairo_move_to (cr, startx, starty)
    cairo_line_to (cr, endx, endy)
    cairo_set_line_join (cr, CAIRO_LINE_JOIN_MITER)
    cairo_stroke (cr)
end
