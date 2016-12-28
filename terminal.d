module BearLibTerminal;

import std.conv;

alias color_t = uint;
alias colour_t = uint;


private const(char*) format(T...)(string s, T args) {
	import std.array: appender;
	import std.format: formattedWrite;
	auto w = appender!string();
	formattedWrite(w, s, args);
	return cast(const char*)w.data;
}

@safe private extern (C) {
	import keycodes;
	int terminal_open();
	void terminal_close();
	int terminal_set8(const char*);
	void terminal_color(color_t);
	void terminal_bkcolor(color_t);
	void terminal_composition(int);
	void terminal_layer(int);
	void terminal_clear();
	void terminal_clear_area(int, int, int, int);
	void terminal_crop(int, int, int, int);
	void terminal_refresh();
	void terminal_put(int, int, int);
	int terminal_pick(int, int, int);
	color_t terminal_pick_color(int, int, int);
	color_t terminal_pick_bkcolor(int, int);
	void terminal_put_ext(int, int, int, int, int, color_t*);
	void terminal_print8(int, int, const char*);
	void terminal_measure8(const char*);
	int terminal_state(int);
	int terminal_check(int);
	int terminal_has_input();
	int terminal_read();
	int terminal_peek();
	color_t terminal_read_str8(int, int, char*, int);
	void terminal_delay(int);
	color_t color_from_name8(const char*);
	color_t color_from_argb(byte, byte, byte, byte);
}

// namespace called "terminal"
//struct terminal { static {
extern (C++, terminal) {


	// Has to be inline, for now
	enum keycode {
		a = 0x04,
		b = 0x05,
		c = 0x06,
		d = 0x07,
		e = 0x08,
		f = 0x09,
		g = 0x0a,
		h = 0x0b,
		i = 0x0c,
		j = 0x0d,
		k = 0x0e,
		l = 0x0f,
		m = 0x10,
		n = 0x11,
		o = 0x12,
		p = 0x13,
		q = 0x14,
		r = 0x15,
		s = 0x16,
		t = 0x17,
		u = 0x18,
		v = 0x19,
		w = 0x1a,
		x = 0x1b,
		y = 0x1c,
		z = 0x1d,
		K_1 = 0x1E,
		K_2 = 0x1F,
		K_3 = 0x20,
		K_4 = 0x21,
		K_5 = 0x22,
		K_6 = 0x23,
		K_7 = 0x24,
		K_8 = 0x25,
		K_9 = 0x26,
		K_0 = 0x27,
		enter = 0x28,
		escape = 0x29,
		backspace = 0x2a,
		tab = 0x2b,
		space = 0x2c,
		minus = 0x2d /*  -  */,
		equals = 0x2e /*  =  */,
		lbracket = 0x2f /*  [  */,
		rbracket = 0x30 /*  ]  */,
		backslash = 0x31 /*  \  */,
		semicolon = 0x33 /*  ,  */,
		apostrophe = 0x34 /*  '  */,
		grave = 0x35 /*  `  */,
		comma = 0x36 /*  ,  */,
		period = 0x37 /*  .  */,
		slash = 0x38 /*  /  */,
		F1 = 0x3A,
		F2 = 0x3B,
		F3 = 0x3C,
		F4 = 0x3D,
		F5 = 0x3E,
		F6 = 0x3F,
		F7 = 0x40,
		F8 = 0x41,
		F9 = 0x42,
		F10 = 0x43,
		F11 = 0x44,
		F12 = 0x45,
		pause = 0x48 /* Pause/Break */,
		insert = 0x49,
		home = 0x4a,
		pageup = 0x4b,
		K_delete = 0x4c,
		end = 0x4d,
		pagedown = 0x4e,
		right = 0x4F /* Right arrow */,
		left = 0x50 /* Left arrow */,
		down = 0x51 /* Down arrow */,
		up = 0x52 /* Up arrow */,
		KP_divide = 0x54 /* '/' on numpad */,
		KP_multiply = 0x55 /* '*' on numpad */,
		KP_minus = 0x56 /* '-' on numpad */,
		KP_plus = 0x57 /* '+' on numpad */,
		KP_enter = 0x58,
		KP_1 = 0x59,
		KP_2 = 0x5A,
		KP_3 = 0x5B,
		KP_4 = 0x5C,
		KP_5 = 0x5D,
		KP_6 = 0x5E,
		KP_7 = 0x5F,
		KP_8 = 0x60,
		KP_9 = 0x61,
		KP_0 = 0x62,
		kp_period = 0x63 /* '.' on numpad */,
		shift = 0x70,
		control = 0x71,
		alt = 0x72,

		/*
		* Mouse events/states
		*/
		mouse_left = 0x80 /* Buttons */,
		mouse_right = 0x81,
		mouse_middle = 0x82,
		mouse_x1 = 0x83,
		mouse_x2 = 0x84,
		mouse_move = 0x85 /* Movement event */,
		mouse_scroll = 0x86 /* Mouse scroll event */,
		mouse_x = 0x87 /* Cusor position in cells */,
		mouse_y = 0x88,
		mouse_pixel_x = 0x89 /* Cursor position in pixels */,
		mouse_pixel_y = 0x8A,
		mouse_wheel = 0x8B /* Scroll direction and amount */,
		mouse_clicks = 0x8C /* Number of consecutive clicks */,

		/*
		* If key was released instead of pressed, it's code will be OR'ed with TK_KEY_RELEASED:
		* a) pressed 'A': 0x04
		* b) released 'A': 0x04|VK_KEY_RELEASED = 0x104
		*/
		key_released = 0x100,

		/*
		* Virtual key-codes for internal terminal states/variables.
		* These can be accessed via terminal_state function.
		*/
		width = 0xC0 /* Terminal window size in cells */,
		height = 0xC1,
		cell_width = 0xC2 /* Character cell size in pixels */,
		cell_height = 0xC3,
		color = 0xC4 /* Current foregroung color */,
		bkcolor = 0xC5 /* Current background color */,
		layer = 0xC6 /* Current layer */,
		composition = 0xC7 /* Current composition state */,
		character = 0xC8 /* Translated ANSI code of last produced character */,
		wcharacter = 0xC9 /* Unicode codepoint of last produced character */,
		event = 0xCA /* Last dequeued event */,
		fullscreen = 0xCB /* Fullscreen state */,

		/*
		* Other events
		*/
		close = 0xe0,
		resized = 0xe1,

		/*
		* Generic mode enum.
		* Right now it is used for composition option only.
		*/
		off = 0,
		on = 1
	}

	int open() { return terminal_open(); };
	void close() { terminal_close(); };
	int set(string s) { return terminal_set8(cast(const char*)s); };
	int setf(T...)(string s, T args) { return terminal_set8(format(s, args)); }
	void color(color_t clr) { terminal_color(clr); };
	void bkcolor(color_t clr) { terminal_bkcolor(clr); };
	void composition(int mode) { terminal_composition(mode); };
	void layer(int lyr) { terminal_layer(lyr); };
	void clear() { terminal_clear(); };
	void clear_area(int x, int y, int w, int h) { terminal_clear_area(x, y, w, h); };
	void crop(int x, int y, int w, int h) { terminal_crop(x, y, w, h); };
	void refresh() { terminal_refresh(); };
	void put(int x, int y, int code) { terminal_put(x, y, code); };
	int pick(int x, int y, int index) { return terminal_pick(x, y, index); };
	color_t pick_color(int x, int y, int index) { return terminal_pick_color(x, y, index); };
	color_t pick_bkcolor(int x, int y) { return terminal_pick_bkcolor(x, y); };
	void put_ext(int x, int y, int dx, int dy, int code, color_t *corners) { terminal_put_ext(x, y, dx, dy, code, corners); };
	void print(int x, int y, string s) { terminal_print8(x, y, cast(const char*)s); };
	void printf(T...)(int x, int y, string s, T args) { terminal_print8(x, y, format(s, args)); };
	void measure(string s) { terminal_measure8(cast(const char*)s); };
	void measuref(T...)(string s, T args) { terminal_measure8(format(s, args)); };
	int state(int slot) { return terminal_state(slot); };
	bool check(int slot) { return terminal_state(slot) > 0; };
	int has_input() { return terminal_has_input(); };
	int read() { return terminal_read(); };
	int peek() { return terminal_peek(); };
	color_t read_str(int x, int y, ref string buffer, /*char *buffer,*/ int max) { char *buf = cast(char*) buffer; color_t tmp = terminal_read_str8(x, y, buf, max); buffer = to!string(buf); return tmp; };
	void delay(int period) { terminal_delay(period); };
	color_t color_from_name(string name) { return color_from_name8(cast(const char*)name); };
}