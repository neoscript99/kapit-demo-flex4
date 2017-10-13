////////////////////////////////////////////////////////////////////////////////
//
//  Kap IT 
//  Copyright 2010/2011 Kap IT 
//  All Rights Reserved. 
//
////////////////////////////////////////////////////////////////////////////////
package fr.kapit.lab.demo.data
{
	
	public class UMLData
	{
		[Bindable]
		public var classs:String="Class";
		
		[Bindable]
		public var attributes:String = "- Attribute 1";
		
		[Bindable]
		public var operations:String = "- Operation 1";
		
		public function clone():UMLData
		{
			var umlData:UMLData = new UMLData();
			umlData.classs = classs;
			umlData.attributes = attributes;
			umlData.operations = operations;
			return umlData;
		}
	}
}
