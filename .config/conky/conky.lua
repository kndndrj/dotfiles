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

    clock ()

    cairo_destroy (cr)
    cairo_surface_destroy (cs)
    cr = nil
end

function draw_line ()
    local red, green, blue, alpha = 1, 1, 1, 1
    local startx = 180
    local starty = 140
    local endx = 711 - startx
    local endy = starty

    cairo_set_line_width (cr, 10)
    cairo_set_line_cap  (cr, CAIRO_LINE_CAP_BUTT)
    cairo_set_source_rgba (cr, red, green, blue, alpha)
    cairo_move_to (cr, startx, starty)
    cairo_line_to (cr, endx, endy)
    cairo_stroke (cr)
end

function clock ()
    -- Presets
    local red, green, blue, alpha = 1, 1, 1, 1
    local center_x = 711 / 2
    local center_y = 220
    cairo_set_line_width (cr, 10)
    cairo_set_line_cap  (cr, CAIRO_LINE_CAP_ROUND)
    cairo_set_source_rgba (cr, red, green, blue, alpha)
    -- Circle presets
    local radius = 160
    -- Line presets
    local m_length = radius * 0.85
    local h_length = radius / 2

    -- Get minutes and hours,
    -- subtract a quarter for coordinate system correction.
    -- radians count the left side (you went to school dewd!).
    local minutes = tonumber (os.date("%M"))
    local hours = tonumber (os.date("%I"))
    local minute = minutes - 15
    local hour = hours + (minutes/60) - 3

    -- Calculate the angles for hours and minutes
    local m_angle = (minute * 2 * math.pi) / 60
    local h_angle = (hour * 2 * math.pi) / 12

    -- Calculate the positions of clock arms,
    -- add the center coordinate for correction
    local m_x = (m_length * math.cos(m_angle)) + center_x
    local m_y = (m_length * math.sin(m_angle)) + center_y
    local h_x = (h_length * math.cos(h_angle)) + center_x
    local h_y = (h_length * math.sin(h_angle)) + center_y

    -- Draw the circle outline
    cairo_arc (cr, center_x, center_y, radius, 0, 2 * math.pi)
    cairo_stroke (cr)
    -- Draw the minute arm
    cairo_move_to (cr, center_x, center_y)
    cairo_line_to (cr, m_x, m_y)
    cairo_stroke (cr)
    -- Draw the hour arm
    cairo_move_to (cr, center_x, center_y)
    cairo_line_to (cr, h_x, h_y)
    cairo_stroke (cr)
end
