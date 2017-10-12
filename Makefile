PYTHON ?= python3

# TODO: add more detailed checks of negative results, i.e. that cells
# fail as expected. Maybe store files with expected console output
# from running tests? Right now, if one of the 'negative' commands
# fails e.g. because a file is missing, we won't see any problems
# unless we inspect the output.

test:
	@# Note: to run the tests, we also need additional dependencies
	@# ("make install-test-deps")
# original tests
	py.test -v tests/ --nbval --current-env --sanitize-with tests/sanitize_defaults.cfg --ignore tests/ipynb-test-samples

############################################################
# should pass
	py.test -v tests2/				 --nbval-require-ref-data --current-env --data-handlers=myhandlers.py
# should fail
	! py.test -v tests3/data_has_changed.ipynb	 --nbval-require-ref-data --current-env --data-handlers=myhandlers.py
############################################################
## test presence/absence of reference data
# should fail
	! py.test -v tests3/missing_reference_data.ipynb --nbval-require-ref-data --current-env --data-handlers=myhandlers.py
# should pass
	py.test -v tests3/missing_reference_data.ipynb	 --nbval		  --current-env --data-handlers=myhandlers.py
# ...and should now pass
	cp tests3/missing_reference_data.nbval.ipynb tests3/now_has_reference_data.ipynb
	py.test -v tests3/now_has_reference_data.ipynb	 --nbval-require-ref-data --current-env --data-handlers=myhandlers.py
############################################################

build-dists:
	rm -rf dist/
	$(PYTHON) setup.py sdist
	$(PYTHON) setup.py bdist_wheel

release: build-dists
	twine upload dist/*


install-test-deps:
	pip install matplotlib sympy
