help:

	@echo "Possible targets:"
	@echo "  test - build all test suites"
	@exit 0

test:

	@tests/run_tests_unix

.PHONY: test help

# vim: ts=4:sw=4:noexpandtab!:
