package fr.kapit.lab.demo.manager
{
	import flash.utils.Dictionary;
	
	public class AssetsManager
	{
		
		
		//priority
		[Embed( source = "/fr/kapit/lab/demo/assets/priorities/priority_1.png")]
		[Bindable] static public var PRIORITY_1:Class;
		[Embed( source = "/fr/kapit/lab/demo/assets/priorities/priority_2.png")]
		[Bindable] static public var PRIORITY_2:Class;
		[Embed( source = "/fr/kapit/lab/demo/assets/priorities/priority_3.png")]
		[Bindable] static public var PRIORITY_3:Class;
		[Embed( source = "/fr/kapit/lab/demo/assets/priorities/priority_4.png")]
		[Bindable] static public var PRIORITY_4:Class;
		[Embed( source = "/fr/kapit/lab/demo/assets/priorities/priority_5.png")]
		[Bindable] static public var PRIORITY_5:Class;
		
		//status
		[Embed( source = "/fr/kapit/lab/demo/assets/status/status_0-4.png")]
		[Bindable] static public var STATUS_0:Class;
		[Embed( source = "/fr/kapit/lab/demo/assets/status/status_1-4.png")]
		[Bindable] static public var STATUS_1:Class;
		[Embed( source = "/fr/kapit/lab/demo/assets/status/status_2-4.png")]
		[Bindable] static public var STATUS_2:Class;
		[Embed( source = "/fr/kapit/lab/demo/assets/status/status_3-4.png")]
		[Bindable] static public var STATUS_3:Class;
		[Embed( source = "/fr/kapit/lab/demo/assets/status/status_4-4.png")]
		[Bindable] static public var STATUS_4:Class;
		[Embed( source = "/fr/kapit/lab/demo/assets/status/status_canceled.png")]
		[Bindable] static public var STATUS_CANCELED:Class;
		[Embed( source = "/fr/kapit/lab/demo/assets/status/status_pause.png")]
		[Bindable] static public var STATUS_PAUSE:Class;
		
		//expand/collapse
		
		[Embed( source = "/fr/kapit/lab/demo/assets/buttons/ICO_arrow_menuAction.png")]
		[Bindable] static public var EXPAND_COLLAPSE_ACTIONSMENU:Class;
		[Embed( source = "/fr/kapit/lab/demo/assets/buttons/BTN_expand.png")]
		[Bindable] static public var EXPAND_NODE:Class;
		[Embed( source = "/fr/kapit/lab/demo/assets/buttons/BTN_collapse.png")]
		[Bindable] static public var COLLAPSE_NODE:Class;

		
		
		//colorPicker
		[Embed( source = "/fr/kapit/lab/demo/assets/buttons/ICO_colorPicker_box.png")]
		[Bindable] static public var COLOR_PICKER_BTN:Class;
		//delete
		[Embed( source = "/fr/kapit/lab/demo/assets/buttons/ICO_delete_box.png")]
		[Bindable] static public var DELETE_TOPIC_BTN:Class;
		//duplicte
		[Embed( source = "/fr/kapit/lab/demo/assets/buttons/ICO_duplicate_box.png")]
		[Bindable] static public var DUPLICATE_TOPIC_BTN:Class;
		//newTopic
		[Embed( source = "/fr/kapit/lab/demo/assets/buttons/ICO_newTopic_box.png")]
		[Bindable] static public var NEW_TOPIC_BTN:Class;
		//shapeStyle
		[Embed( source = "/fr/kapit/lab/demo/assets/buttons/ICO_shapeStyle_box.png")]
		[Bindable] static public var SHAPE_STYLE_BTN:Class;
		//strokeStyle
		[Embed( source = "/fr/kapit/lab/demo/assets/buttons/ICO_strokeStyle_box.png")]
		[Bindable] static public var STROKE_STYLE_BTN:Class;
		//priority
		[Embed( source = "/fr/kapit/lab/demo/assets/buttons/ICO_priority_menuAction.png")]
		[Bindable] static public var PRIORITY:Class;
		//status
		[Embed( source = "/fr/kapit/lab/demo/assets/buttons/ICO_status_menuAction.png")]
		[Bindable] static public var STATUS:Class;
		//note
		[Embed( source = "/fr/kapit/lab/demo/assets/buttons/ICO_note_menuAction.png")]
		[Bindable] static public var NOTE:Class;
		
		//NoteButton
		[Embed( source = "/fr/kapit/lab/demo/assets/note.png")]
		[Bindable] static public var NOTED:Class;
		
		//Color
		[Embed( source = "/fr/kapit/lab/demo/assets/colors/ICO_boxColor_blue.png")]
		[Bindable] static public var DEEP_SKY_BLUE:Class;
		[Embed( source = "/fr/kapit/lab/demo/assets/colors/ICO_boxColor_green.png")]
		[Bindable] static public var LIGHT_GREEN:Class;
		[Embed( source = "/fr/kapit/lab/demo/assets/colors/ICO_boxColor_grey.png")]
		[Bindable] static public var LIGHT_GREY:Class;
		[Embed( source = "/fr/kapit/lab/demo/assets/colors/ICO_boxColor_orange.png")]
		[Bindable] static public var ORANGE_RED:Class;
		[Embed( source = "/fr/kapit/lab/demo/assets/colors/ICO_boxColor_red.png")]
		[Bindable] static public var RED:Class;
		

	}
}