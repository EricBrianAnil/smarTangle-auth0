'''
How to run?
Copy this file to the django directory and run the following command
python manage.py shell < dataPopulator.py
'''

from stwms_app.models import *
from datetime import datetime, timedelta, timezone
from random import randrange
from seriesGenerator import SeriesGenerator

# Config
stores = ['S1', 'S2', 'S3', 'S4']
rawMaterials = ['101', '102', '103', '104', '105', '106']
dateTime = datetime(2020, 6, 28, tzinfo=timezone.utc)
openingTime = [10, 30]
closingTime = [18, 30]
timeInterval = timedelta(minutes=15)

#Series

seriesDict = {}
for store in stores:
	seriesDict[store] = {}
	baseline = randrange(300, 700)
	for rm in rawMaterials:
		baseline = baseline + randrange(-50, 50)
		sg = SeriesGenerator(baseline)
		sg.randomInit()
		seriesDict[store][rm] = sg.generate()

# Init
iteratorVal = 0

while(dateTime.replace(tzinfo=timezone.utc).timestamp() < datetime.now().replace(tzinfo=timezone.utc).timestamp()):
	for rm_id in rawMaterials:
		rm = RawMaterials.objects.get(rawMaterial_id=rm_id)

		for s_id in stores:
			s = StoreDetails.objects.get(store_id=s_id)

			closeTime = dateTime.replace(hour=closingTime[0], minute=closingTime[1])
			dateTime = dateTime.replace(hour=openingTime[0], minute=openingTime[1])

			while(dateTime.replace(tzinfo=timezone.utc).timestamp() < closeTime.replace(tzinfo=timezone.utc).timestamp()):

				units = seriesDict[s_id][rm_id][iteratorVal]
				t = TransactionHistory(rawMaterial_id=rm, storeId=s, units=units)
				t.save()
				t.dateTime = dateTime
				t.save()

				iteratorVal += 1
				dateTime = dateTime + timeInterval
				print(t)
			print('==========================')
		print('---------------------------')
	print('..........................')

	dateTime = dateTime + timedelta(days=1)
