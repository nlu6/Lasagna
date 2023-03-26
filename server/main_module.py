import smtplib
from email.mime.text import MIMEText
from twilio.rest import Client

sending_email = "lasagna.messaging@gmail.com"
email_password = "U4CbQHz2g7dqmGAN"
receiving_emails = []
email_message = ''
carrier_domains = {"Verizon Wireless": '@vtext.com', 'AT&T Wireless': '@txt.att.net', 'T-Mobile USA, Inc': '@tmomail.net'}
twilio_account_sid = "ACc8687d8bfd3bcfa09cb9bb6f3122e075"
twilio_auth_token = "05bd133119bde7b7c07830e4fef042df"

def setReceiving(number_string):
	"""
	Parses comma-separated string of phone numbers, returns list of strings
	"""
	global receiving_emails

	phone_numbers = str(number_string).split(',')
	phone_numbers = [number.strip() for number in phone_numbers]
	receiving_numbers = phone_numbers
	receiving_emails = _setDomains(receiving_numbers)
	return receiving_emails

def getReceiving():
	if len(receiving_emails) == 0:
		return 'List is empty'
	return receiving_emails

def _setDomains(number_list):
	new_list = []
	carrier = ''
	index = 0
	for number in number_list:
		if len(number_list[index]) != 10:
			new_list.append('')
			index += 1
		else:
			carrier = getCarrier(number_list[index])
			if carrier not in carrier_domains:
				new_list.append('')
				index += 1
			else:
				new_list.append(str(number_list[index] + carrier_domains[carrier]))
				index += 1
	return new_list

def setMessage(message):
	global email_message
	email_message = message

def getMessage():
	return email_message


def getCarrier(phone_number):
	"""
	Sign-in to twilio for carrier lookup, return name of carrier.
	"""
	client = Client(twilio_account_sid, twilio_auth_token)
	lookup = client.lookups.phone_numbers("+1"+str(phone_number)).fetch(type='carrier')
	#print(lookup.carrier['name']) #Testing purposes only
	return lookup.carrier['name']


def sendMessages():
	if len(receiving_emails) == 0:
		return
	server = smtplib.SMTP("smtp-relay.sendinblue.com", 587)
	server.starttls()
	server.login(sending_email, email_password)
	index = 0

	for x in receiving_emails:
		msg = MIMEText(email_message)
		msg['Subject'] = ''
		msg['From'] = ""
		msg['To'] = receiving_emails[index]
		server.sendmail(sending_email, receiving_emails[index], msg.as_string())
		index += 1

	server.quit()