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
public class GraphLibrary
{
	/**
	 * Graphe definition identifier : default XML graphe.
	 */
	public static const DEFAULT_XML:String = "graphe.defaultXML";

	/*
	* !NOTICE!
	* To embed an XML file, you have to set the mimeType
	* to "application/octet-stream" (will be fixed for klovis 0.9.4)
	*/

	/**
	 * @private
	 * Graphe definition : default XML graphe.
	 */
	[Embed(source="/data/graphes/defaultXML.xml", mimeType="application/octet-stream")]
	private static var __xmlGrapheDefault:Class;


	/**
	 * @private
	 * Instance of the asset library.
	 */
	private static var __objLibrary:IAssetLibrary = new CompositeAssetLibrary();

	/**
	 * @private
	 * XML data, supplied as a file by the user.
	 */
	private static var __xmlUserData:XML = null;


	/**
	 * @private
	 * Static initialization.
	 */
	private static function initialize():void
	{
		__objLibrary.setDefinition(DEFAULT_XML, __xmlGrapheDefault);
	}

	/**
	 * Returns an instance of a definition, as a <code>XML</code> instance.
	 * If the <code>bAsNew</code> parameter is set to <code>true</code>,
	 * then a brand new instance will be created, if not a previous definition
	 * instance will be returned.
	 *
	 * @param strName
	 * 		name of the definition
	 * @param bAsNew
	 * 		ask for a new asset instance
	 * @return
	 * 		a XML instance.
	 *
	 * @throws ReferenceError
	 * 		No definition exists with the specified name.
	 * @throws TypeError
	 * 		The definition does not stand for a XML
	 */
	public static function getAsXML(strName:String, bAsNew:Boolean=false):XML
	{
		return __objLibrary.getAsXML(strName, bAsNew);
	}

	/**
	 * XML data, supplied as a file by the user.
	 */
	public static function get userData():XML
	{
		return __xmlUserData;
	}
	/** @private */
	public static function set userData(xmlValue:XML):void
	{
		__xmlUserData = xmlValue;
	}


	/**
	 * @private
	 * Static initializer.
	 */
	initialize();

}
}