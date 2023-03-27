import main_module

test = main_module

def test_getMessage():
	assert test.getMessage() == ''

def test_setMessage():
	assert test.setMessage('Test test 1234') == 'Test test 1234'

def test_getReceiving():
	assert test.getReceiving() == 'List is empty'

def test_setReceiving():
	assert test.setReceiving('6692248986, 8082698655') == ["6692248986@txt.att.net", "8082698655@vtext.com"]

def test_getCarrier():
	assert test._getCarrier('8082698655') == "Verizon Wireless"
