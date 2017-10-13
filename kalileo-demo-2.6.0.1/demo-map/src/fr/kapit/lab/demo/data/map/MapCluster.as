package fr.kapit.lab.demo.data.map
{
	import mx.collections.ArrayCollection;

	public class MapCluster extends MapEntity
	{
		protected var _children:ArrayCollection; 
		[Bindable]
		public function get children():ArrayCollection
		{
			return _children;
		}
		public function set children(value:ArrayCollection /* Station */):void
		{
			_children = value;
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
		
		protected var _aggregationChanged:Boolean;
		public function get aggregationChanged():Boolean
		{
			return _aggregationChanged;
		}
		public function set aggregationChanged(value:Boolean):void
		{
			_aggregationChanged = value;
		}
		
		
		protected var _internationalFlights:Number = 100;
		public function get internationalFlights():Number
		{
			return _internationalFlights;
		}

		protected var _nationalFlights:Number=200;
		public function get nationalFlights():Number
		{
			return _nationalFlights;
		}
		
		protected var _airportsList:ArrayCollection;
		public function get airportsList():ArrayCollection
		{
			return _airportsList;
		}

		
		public function MapCluster()
		{
		}
		
		public function computeAggregatedValues():void
		{
			_internationalFlights = _nationalFlights =0;
			_airportsList = new ArrayCollection();
			var mapEntity:MapEntity;
			for each(mapEntity in children)
			{
				if(mapEntity is MapCluster)
				{
					MapCluster(mapEntity).computeAggregatedValues();
					_internationalFlights += MapCluster(mapEntity).internationalFlights;
					_nationalFlights += MapCluster(mapEntity).nationalFlights;
					_airportsList.addAll(MapCluster(mapEntity).airportsList);
				}
				else if(mapEntity is MapAirport)
				{
					_internationalFlights += MapAirport(mapEntity).internationalFlights;
					_nationalFlights += MapAirport(mapEntity).nationalFlights;
					_airportsList.addItem(MapAirport(mapEntity).type);
				}
			}
		}
	}
}