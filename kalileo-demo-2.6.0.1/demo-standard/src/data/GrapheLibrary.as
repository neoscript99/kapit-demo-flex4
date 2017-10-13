package data
{
import fr.kapit.actionscript.asset.BaseAssetLibrary;
import fr.kapit.actionscript.asset.CompositeAssetLibrary;
import fr.kapit.actionscript.asset.IAssetLibrary;

/**
 * A library of embedded graphes definitions.
 * Definitions are embedded at compile time, thanks to
 * the <code>[Embed]</code> metadata tag.
 */
public class GrapheLibrary
{
	/**
	 * Graphe definition identifier : default XML graphe.
	 */
	public static const DEFAULT_XML:String = "graphes.nodeXML";

	/*
	* !NOTICE!
	* To embed an XML file, you have to set the mimeType
	* to "application/octet-stream" (will be fixed for klovis 0.9.4)
	*/

	/**
	 * @private
	 * Graphe definition : default XML graphe.
	 */
	[Embed(source="/data/graphes/nodeXML.xml", mimeType="application/octet-stream")]
	private static var _grapheDefault:Class;


	/**
	 * @private
	 * Instance of the asset library.
	 */
	private static var _library:IAssetLibrary = new CompositeAssetLibrary();

	/**
	 * @private
	 * XML data, supplied as a file by the user.
	 */
	private static var _userData:XML = null;


	/**
	 * @private
	 * Static initialization.
	 */
	private static function initialize():void
	{
		_library.setDefinition(DEFAULT_XML, _grapheDefault);
	}

	/**
	 * Returns an instance of a definition, as a <code>XML</code> instance.
	 * If the <code>asNew</code> parameter is set to <code>true</code>,
	 * then a brand new instance will be created, if not a previous definition
	 * instance will be returned.
	 *
	 * @param name
	 * 		name of the definition
	 * @param asNew
	 * 		ask for a new asset instance
	 * @return
	 * 		a XML instance.
	 *
	 * @throws ReferenceError
	 * 		No definition exists with the specified name.
	 * @throws TypeError
	 * 		The definition does not stand for a XML
	 */
	public static function getAsXML(name:String, asNew:Boolean=false):XML
	{
		return _library.getAsXML(name, asNew);
	}

	/**
	 * XML data, supplied as a file by the user.
	 */
	public static function get userData():XML
	{
		return _userData;
	}
	/** @private */
	public static function set userData(xmlValue:XML):void
	{
		_userData = xmlValue;
	}


	/**
	 * @private
	 * Static initializer.
	 */
	initialize();

}
}