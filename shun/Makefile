CONTENTDIR = .
MasterFilename = main

latexExe = pdflatex
latexOption =
SourceFiles = $(MasterFilename).tex $(CONTENTDIR)/*.tex $(CONTENTDIR)/bib/*.bib
Viewer = open -a Skim.app 

OriginalRefBib = $(HOME)/Documents/References/bib/ref.bib
OriginalRefBibSrc = $(HOME)/Documents/References/bib/bibdesk.bib
OriginalRefBibClean = $(HOME)/Documents/References/bib/clean.pl


all:
	$(latexExe) $(latexOption) $(MasterFilename)

full: $(SourceFiles)
	@echo ----------------------------------------------------------------
	@echo --- Step 1 -----------------------------------------------------
	@echo ----------------------------------------------------------------
	$(latexExe) $(latexOption) $(MasterFilename)
	@echo ----------------------------------------------------------------
	@echo --- Step 2 -----------------------------------------------------
	@echo ----------------------------------------------------------------
	bibtex $(MasterFilename)
	@echo ----------------------------------------------------------------
	@echo --- Step 3 -----------------------------------------------------
	@echo ----------------------------------------------------------------
	$(latexExe) $(latexOption) $(MasterFilename)
	@echo ----------------------------------------------------------------
	@echo --- Step 4 -----------------------------------------------------
	@echo ----------------------------------------------------------------
	$(latexExe) $(latexOption) $(MasterFilename)

bib/ref: $(OriginalRefBib)
	$(OriginalRefBibClean)
	cp -f $(OriginalRefBib) bib/ref.bib


view: $(MasterFilename).pdf
	$(Viewer) $(MasterFilename).pdf &

clean:
	rm -f *.idx *.ilg *.ind *.out *.toc *.aux *.log *.bbl *.blg *lof *.lot *.dvi *.ps *.pdf missfont.log texput.log *.pdfsync *.rel *~
	rm -rf auto

present:
	pdflatex present.tex
	bibtex present
	pdflatex present.tex
	pdflatex present.tex
