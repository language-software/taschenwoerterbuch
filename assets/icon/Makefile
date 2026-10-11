INKSCAPE ?= inkscape
SRC      := svg/icon.svg
DST		 := png/icon_
FORMAT   := .png
SIZE     ?= 1024

DARK_BACKGROUND := \#181818

OUT := light dark

.PHONY: all clean

all: $(OUT)

# the icon is designed for light mode so no changes needed
light: $(SRC)
	$(INKSCAPE) $< \
		--export-type=png \
		--export-width=$(SIZE) --export-height=$(SIZE) \
		--export-filename=$(DST)$@$(FORMAT)

dark: $(SRC)
	$(INKSCAPE) $< --actions="\
select-by-id:background;object-set-property:fill,$(DARK_BACKGROUND);select-clear;\
export-width:$(SIZE);export-height:$(SIZE);\
export-filename:$(DST)$@$(FORMAT);export-do"

clean:
	rm -f $(OUT)