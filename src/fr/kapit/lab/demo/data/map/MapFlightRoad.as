package fr.kapit.lab.demo.data.map
{
	public class MapFlightRoad extends MapEntity
	{
		protected var _sourceNode:String;
		[Bindable]
		public function get sourceNode():String
		{
			return _sourceNode;
		}
		public function set sourceNode(value:String):void
		{
			_sourceNode = value;
		}
		
		protected var _targetNode:String;
		[Bindable]
		public function get targetNode():String
		{
			return _targetNode;
		}
		
		public function set targetNode(value:String):void
		{
			_targetNode = value;
		}
		
		protected var _priority:Number;
		[Bindable]
		public function get priority():Number
		{
			return _priority;
		}
		public function set priority(value:Number):void
		{
			_priority = value;
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

		protected var _flights:Number;
		[Bindable]
		public function get flights():Number
		{
			return _flights;
		}
		public function set flights(value:Number):void
		{
			_flights = value;
		}
		
		public function MapFlightRoad()
		{
		}
	}
}