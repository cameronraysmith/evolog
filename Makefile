.PHONY: default arxiv clean cleanall test

#---------------------------------------------
# Define variables

# list of automatic variables
# http://www.gnu.org/software/make/manual/html_node/Automatic-Variables.html#Automatic-Variables

PROJECTNAME = evolog

TOPTEX = notes.tex

TOPPDFFILE = $(TOPTEX:.tex=.pdf)

TOPBBLFILE = $(TOPTEX:.tex=.bbl)

BIBFILES = notes.bib

FIGFILES = $(shell grep -v '^%' *.tex tex/*.tex | grep -ohP 'fig/.*(?=\})')

TEXFILES = $(shell ls tex/*.tex)

#---------------------------------------------
# Default target
# will run with
# >make
# alone

default: $(TOPPDFFILE)

#----------------------------------------------
# Additional targets

arxiv:
	latexpand $(TOPTEX) > combined.tex
	sed -i 's/\\makeatletter{}//g' combined.tex
	cp $(TOPBBLFILE) combined.bbl
	tar --transform='flags=r;s|combined|paper|' -cvzf arxiv`date +"%m%d%Y"`.tar.gz combined.tex combined.bbl $(FIGFILES)

$(TOPPDFFILE): $(TOPTEX) $(BIBFILES)
	if which latexmk > /dev/null 2>&1 ;\
	then latexmk -pdf $<;\
	else echo "Install latexmk"; fi

clean:
	rm -f *.aux *.bbl *.blg *.brf *.dvi *.fdb_latexmk *.fls *.lof *.log \
	      *.lot *.nav *.out *.pre *.snm *.synctex.gz *.toc *.dot *-dot2tex-*

cleanall: clean
	rm -f $(TOPPDFFILE)

test:
	echo $(TOPPDFFILE)

#---------------------------------------------
