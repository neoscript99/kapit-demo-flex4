package fr.kapit.lab.demo.util
{
import fr.kapit.actionscript.lang.ArrayUtil;
import fr.kapit.diagrammer.base.uicomponent.container.DiagramColumn;
import fr.kapit.diagrammer.base.uicomponent.container.DiagramLane;
import fr.kapit.diagrammer.base.uicomponent.container.DiagramTable;
import fr.kapit.diagrammer.base.uicomponent.container.DiagramTableCell;
import fr.kapit.diagrammer.renderers.DefaultEditorGroupRenderer;
import fr.kapit.diagrammer.renderers.DefaultEditorRenderer;
import fr.kapit.visualizer.base.IGroup;
import fr.kapit.visualizer.base.ILink;
import fr.kapit.visualizer.base.ISprite;
import fr.kapit.visualizer.renderers.DefaultItemRenderer;

public class SelectionUtil
{
	/**
	 * Extracts nodes / groups / edges (links) from the given list
	 * of diagramming elements.
	 *
	 * @param list
	 * 		list of elements
	 * @param nodes
	 * 		list of nodes to update
	 * @param groups
	 * 		list of groups to update
	 * @param edges
	 * 		list of links to update
	 */
	public static function explodeList(list:Array, nodes:Array, groups:Array, edges:Array):void
	{
		var sprite:ISprite;
		var link:ILink;
		
		for each (var item:Object in list)
		{
			sprite = item as ISprite;
			if (null != sprite)
			{
				if(sprite is DiagramColumn || sprite is DiagramLane || sprite is DiagramTable || sprite is DiagramTableCell)
				{
					// do nothing
				}
				else
				{
					if (sprite.isGroup )
						groups.push(sprite);
					else
						nodes.push(sprite);
				}
				continue;
			}
			
			link = item as ILink;
			if (null != link)
				edges.push(link);
		}
	}
	
	
	/**
	 * Extracts nodes from the given list of diagramming elements.
	 *
	 * @param list
	 * 		list of elements
	 * @param nodes
	 * 		list of nodes to update
	 */
	public static function extractNodes(list:Array, nodes:Array):void
	{
		var groups:Array = [];
		var edges:Array = [];
		explodeList(list, nodes, groups, edges);
	}
	
	/**
	 * Extracts groups from the given list of diagramming elements.
	 *
	 * @param list
	 * 		list of elements
	 * @param groups
	 * 		list of groups to update
	 */
	public static function extractGroups(list:Array, groups:Array):void
	{
		var nodes:Array = [];
		var edges:Array = [];
		explodeList(list, nodes, groups, edges);
	}
	
	/**
	 * Extracts edges (links) from the given list of diagramming elements.
	 *
	 * @param list
	 * 		list of elements
	 * @param edges
	 * 		list of links to update
	 */
	public static function extractEdges(list:Array, edges:Array):void
	{
		var nodes:Array = [];
		var groups:Array = [];
		explodeList(list, nodes, groups, edges);
	}
	
	
	/**
	 * Filters out nodes from the given list, returns the filtered list.
	 *
	 * @param list
	 * 		list of elements to filter
	 * @return
	 * 		filtered list (no nodes)
	 */
	public static function removeNodesFrom(list:Array):Array
	{
		var result:Array = [];
		var sprite:ISprite;
		
		for each (var item:Object in list)
		{
			sprite = item as ISprite;
			if (null != sprite)
			{
				if (! sprite.isGroup)
					continue;
			}
			result.push(item);
		}
		return result;
	}
	
	/**
	 * Filters out groups from the given list, returns the filtered list.
	 *
	 * @param list
	 * 		list of elements to filter
	 * @return
	 * 		filtered list (no groups)
	 */
	public static function removeGroupsFrom(list:Array):Array
	{
		var result:Array = [];
		var sprite:ISprite;
		
		for each (var item:Object in list)
		{
			sprite = item as ISprite;
			if (null != sprite)
			{
				if (sprite.isGroup)
					continue;
			}
			result.push(item);
		}
		return result;
	}
	
	/**
	 * Filters out edges (links) from the given list, returns the filtered list.
	 *
	 * @param list
	 * 		list of elements to filter
	 * @return
	 * 		filtered list (no links)
	 */
	public static function removeEdgesFrom(list:Array):Array
	{
		var result:Array = [];
		var link:ILink;
		
		for each (var item:Object in list)
		{
			link = item as ILink;
			if (null != link)
			{
				continue;
			}
			result.push(item);
		}
		return result;
	}
	
	
	/**
	 * Returns a list of "top-most" elements extracted from the given
	 * list of elements.
	 * "top most" means elements, from <code>aList</code>, not contained
	 * by any other elements from <code>aList</code>.
	 *
	 * @param list
	 * 		list of elements
	 * @return
	 * 		list of "top most" elements
	 */
	public static function onlyTopMostElements(list:Array):Array
	{
		// clone given list
		var result:Array = list.concat();
		var nodes:Array = [];
		var groups:Array = [];
		var edges:Array = [];
		
		explodeList(list, nodes, groups, edges);
		// sort on group depth : a lower value means that a group
		// is contained inside fewer "parent" groups, the group may
		// contain other groups
		var sortedGroups:Array = groups.sortOn("subGroupDepth", Array.NUMERIC);
		var sprites:Array = [];
		
		for each (var group:IGroup in sortedGroups)
		{
			getSprites(group, sprites);
		}
		for each (var sprite:Object in sprites)
		{
			ArrayUtil.removeItem(result, sprite);
		}
		
		return result;
	}
	
	
	/**
	 * @private
	 * Get recursively all sprites (nodes and groups) under the given group.
	 *
	 * @param group
	 * 		source group to get children from
	 * @param sprites
	 * 		list of sprites to update
	 * @param depth
	 * 		max depth in recusrion
	 */
	private static function getSprites(group:IGroup, sprites:Array, depth:int=-1):void
	{
		// depth limit
		if (0 == depth)
			return;
		for each (var sprite:Object in group.sprites)
		{
			sprites.push(sprite);
			if (sprite is IGroup)
			{
				getSprites(IGroup(sprite), sprites, depth-1);
			}
		}
	}
	
	
	/**
	 * Returns <code>true</code> if at least one element of the given list
	 * is currently being edited
	 *
	 * @see fr.kapit.diagrammer.renderers.DefaultEditorRenderer#isEditing
	 *
	 * @param list
	 * 		list of elements
	 * @return
	 * 		true if at least one of the element is being edited,
	 * 		false otherwise
	 */
	public static function isEditingElements(list:Array):Boolean
	{
		var elements:Array = removeEdgesFrom(list);
		
		for each (var element:* in elements)
		{
			if(element is IGroup)
			{
				var groupRenderer:DefaultEditorGroupRenderer = element.itemRenderer as DefaultEditorGroupRenderer;
				if (null == groupRenderer)
					continue;
				if (groupRenderer.isEditing)
					return true;
			}
			
			if(element is ISprite)
			{
				var nodeRenderer:DefaultEditorRenderer = element.itemRenderer as DefaultEditorRenderer;
				if (null == nodeRenderer)
					continue;
				if (nodeRenderer.isEditing)
					return true;
			}
		}
		return false;
	}
	
}
}