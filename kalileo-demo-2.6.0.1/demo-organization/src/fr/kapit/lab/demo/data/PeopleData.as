package fr.kapit.lab.demo.data
{
	public class PeopleData
	{
		[bindable]
		public var imageClass:Class;
		[Bindable]
		public var type:String;
		public function clone():PeopleData
		{
			var peopleData:PeopleData = new PeopleData();
			peopleData.imageClass = imageClass;
			peopleData.type = type;
			return peopleData;
		}
	}
}