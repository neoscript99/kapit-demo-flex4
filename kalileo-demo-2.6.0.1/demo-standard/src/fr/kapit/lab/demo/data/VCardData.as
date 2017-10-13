////////////////////////////////////////////////////////////////////////////////
//
//  Kap IT 
//  Copyright 2010/2011 Kap IT 
//  All Rights Reserved. 
//
////////////////////////////////////////////////////////////////////////////////
package fr.kapit.lab.demo.data
{
	
	public class VCardData
	{
		
		[Bindable]
		public var name:String = "John";
		
		[Bindable]
		public var job:String = "Actor";
		
		[Bindable]
		public var imageNumber:int = 0;
		
		public function clone():VCardData
		{
			var vcard:VCardData = new VCardData();
			vcard.name = this.name;
			vcard.job = this.job;
			vcard.imageNumber = this.imageNumber;
			
			return vcard;
		}
	}
}
