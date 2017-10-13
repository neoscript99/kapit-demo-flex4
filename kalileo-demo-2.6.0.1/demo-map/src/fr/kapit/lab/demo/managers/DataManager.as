////////////////////////////////////////////////////////////////////////////////
//
//  Kap IT 
//  Copyright 2010/2011 Kap IT 
//  All Rights Reserved. 
//
////////////////////////////////////////////////////////////////////////////////
package fr.kapit.lab.demo.managers
{
import flash.utils.Dictionary;

import fr.kapit.lab.demo.data.map.MapAirport;
import fr.kapit.lab.demo.data.map.MapCluster;
import fr.kapit.lab.demo.data.map.MapDataProvider;
import fr.kapit.lab.demo.data.map.MapEntity;
import fr.kapit.lab.demo.data.map.MapFlightRoad;
import fr.kapit.lab.demo.ui.components.map.MapVisualizer;
import fr.kapit.visualizer.Visualizer;
import fr.kapit.visualizer.base.ILink;
import fr.kapit.visualizer.base.ISprite;

/**
 * Helper Class to simulate remote data control on the graph via Binding.
 */
public class DataManager
{
	protected var _dataProvider:MapDataProvider;

	[Bindable]
	public function get dataProvider():MapDataProvider
	{
		return _dataProvider;
	}

	public function set dataProvider(value:MapDataProvider):void
	{
		_dataProvider = value;
		generateData();
	}

	protected var _airports:Array;

	protected var _roads:Array;

	protected var _startAirportsValues:Dictionary;

	protected var _startRoadsValues:Dictionary;

	public function DataManager()
	{
	}

	private function generateData():void
	{
		//Initializing Maps
		_airports = [];
		_roads = [];
		_startAirportsValues = new Dictionary();
		_startRoadsValues = new Dictionary();
		//Registering nodes
		var mapEntity:MapEntity;
		var children:Array = _dataProvider.airportsDataProvider.source.concat();
		while (children.length>0)
		{
			mapEntity = children.pop();
			if (mapEntity is MapCluster)
			{
				children = children.concat(MapCluster(mapEntity).children.source.concat());
			}
			else
			{
				_startAirportsValues[mapEntity.uid] = [MapAirport(mapEntity).internationalFlights,MapAirport(mapEntity).nationalFlights];
				_airports.push(mapEntity);
			}
		}
		//Registering links
		children = _dataProvider.flightRoadsDataProvider.source.concat();
		while (children.length>0)
		{
			mapEntity = children.pop();
			_startRoadsValues[mapEntity.uid] = [MapFlightRoad(mapEntity).flights,MapFlightRoad(mapEntity).flightsCapacity];
			_roads.push(mapEntity);
		}
	}

	public function reset():void
	{
		var mapAirport:MapAirport;
		for each (mapAirport in _airports)
		{
			mapAirport.internationalFlights = _startAirportsValues[mapAirport.uid][0];
			mapAirport.nationalFlights = _startAirportsValues[mapAirport.uid][1];
		}
		var mapFlightRoad:MapFlightRoad;
		for each (mapFlightRoad in _roads)
		{
			mapFlightRoad.flights = _startRoadsValues[mapFlightRoad.uid][0];
			mapFlightRoad.flightsCapacity = _startRoadsValues[mapFlightRoad.uid][1];
		}

	}

}
}
