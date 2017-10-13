package fr.kapit.lab.demo.data.map
{
	public class MapAirport extends MapEntity
	{
		public function MapAirport()
		{
			super();
		}
		
		protected var _longitude:Number = 0;
		[Bindable]
		public function get longitude():Number
		{
			return _longitude;
		}
		public function set longitude(value:Number):void
		{
			_longitude = value;
		}
		
		protected var _latitude:Number = 0;
		[Bindable]
		public function get latitude():Number
		{
			return _latitude;
		}
		public function set latitude(value:Number):void
		{
			_latitude = value;
		}
		
		protected var _country:String;
		[Bindable]
		public function get country():String
		{
			return _country;
		}
		public function set country(value:String):void
		{
			_country = value;
		}
		
		protected var _flightsCapacity:Number;
		[Bindable]
		public function get flightsCapacity():Number
		{
			return _flightsCapacity;
		}
		public function set flightsCapacity(value:Number):void
		{
			_flightsCapacity = value;
		}

		protected var _internationalFlights:Number;
		[Bindable]
		public function get internationalFlights():Number
		{
			return _internationalFlights;
		}
		public function set internationalFlights(value:Number):void
		{
			_internationalFlights = value;
		}

		protected var _nationalFlights:Number;
		[Bindable]
		public function get nationalFlights():Number
		{
			return _nationalFlights;
		}
		public function set nationalFlights(value:Number):void
		{
			_nationalFlights = value;
		}

	}
}