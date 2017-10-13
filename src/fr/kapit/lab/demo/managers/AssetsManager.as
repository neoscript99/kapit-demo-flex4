////////////////////////////////////////////////////////////////////////////////
//
//  Kap IT 
//  Copyright 2010/2011 Kap IT 
//  All Rights Reserved. 
//
////////////////////////////////////////////////////////////////////////////////
package fr.kapit.lab.demo.managers
{

public class AssetsManager
{

	[Embed(source="/assets/world.png")]
	[Bindable]
	public static var IMG_WORLD_VIEW:Class;

	[Embed(source="/assets/city.png")]
	[Bindable]
	public static var IMG_CITY_VIEW:Class;

}
}
