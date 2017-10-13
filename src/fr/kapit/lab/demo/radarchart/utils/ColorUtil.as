package fr.kapit.lab.demo.radarchart.utils
{
public class ColorUtil
{
	private static const _BLUE:uint = 0x0000FF;
	private static const _RED:uint = 0xFF0000;

	private static const _LG:Number = 1021;
	
	private static var _colors:Vector.<uint>;
	
	public function ColorUtil()
	{
	}
	
	public static function getColors(length:uint):Vector.<uint>
	{
		if (length == 0)
			return null;
		
		var v:Vector.<uint> = new Vector.<uint>(length);
		v[0] = _BLUE;
		if (length == 1)
			return v;
		
		v[length - 1] = _RED;
		if (length == 2)
			return v;
		
		if (!_colors)
			generateColors();

		var r:Number = (_LG - 2) / (length - 1);
		var i:uint;
		for (i = 1; i < length - 1; i++)
			v[i] = _colors[Math.round(i * r + 1)];

		return v;
	}
	
	public static function getColor(value:Number):uint
	{
		if (isNaN(value))
			value = 0.5;
		
		return rgb(r(value), g(value), b(value));
	}
	
	private static function generateColors():void
	{
		_colors = new Vector.<uint>(_LG);
		
		var i:uint;
		while (i++ < _LG)
			_colors[i - 1] = getColor(i / _LG);
	}
	
	/**
	 * @private
	 */
	private static function g(c:Number):uint
	{
		if (c >= 0.25 && c <= 0.75)
			return 255;
		else if (c < 0.25)
			return uint(c / 0.25 * 255);

		return uint((1 - c) / 0.25 * 255);
	}
	
	/**
	 * @private
	 */
	private static function b(c:Number):uint
	{
		if (c <= 0.25)
			return 255;
		else if (c >= 0.5)
			return 0;
		
		return 255 - uint((c - 0.25) / 0.25 * 255)
	}
	
	/**
	 * @private
	 */
	private static function r(c:Number):uint
	{
		if (c <= 0.5)
			return 0;
		else if (c >= 0.75)
			return 255;
		return uint((c - 0.5) / 0.25 * 255);
	}
	
	/**
	 * @private
	 */
	private static function rgb(r:uint, g:uint, b:uint):uint
	{
		return Math.min(Math.max(0, b), 0xFF) + 256 * (Math.min(Math.max(0, g), 0xFF) + 256 * Math.min(Math.max(0, r), 0xFF));
	}
}
}