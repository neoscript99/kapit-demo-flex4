package fr.kapit.lab.demo.elasticsearch.model
{
[Bindable]
[RemoteClass]
public class AmazonBook
{
	public var title:String;
	public var author:String;
	public var edition:String;
	public var publisher:String;
	public var numberOfPages:Number;
	public var image:String;
	public var publishingDate:String;
	private var _price:String;
	public var priceRange:String;
	public var language:String;
	public var description:String;
	
	public function AmazonBook()
	{	
	}
	
	public function get price():String
	{
		return _price;
	}
	public function set price(value:String):void
	{
		_price = value;
		var coeff:uint = int(Number(value)/20);
		priceRange = (coeff*20+1)+"$-"+((coeff+1)*20)+"$";
	}


	public function get firstLetter():String
	{
		if (! title)
			return null;
		return title.charAt(0).toLocaleUpperCase();
	}
}
}