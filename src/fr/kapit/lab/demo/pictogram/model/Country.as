package fr.kapit.lab.demo.pictogram.model
{
public class Country
{
	private const _startYear:uint = 1960;
	private const _endYear:uint	= 2007;
	
	public var name:String;

	public var value:Number;

	private var _code:String;

	private var _datas:Array;
	
	public function Country(source:XML)
	{
		name = source.@name;
		_code = source.@code;
		_datas = String(source.@datas).split(";");
	}
	
	public function get url():String
	{
		return "./fr/kapit/lab/demo/pictogram/assets/images/" + _code + ".png";
	}
	
	public function getData(year:uint):Number
	{
		return Number(_datas[year - _startYear])
	}
}
}