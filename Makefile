install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt
		
test:
	python -m pytest -vv test_hello.py
	
lint:
	pylint --disable=R,c hello.py
	
all: install lint test
