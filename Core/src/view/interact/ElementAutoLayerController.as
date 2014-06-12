package view.interact
{
	
	import com.kvs.utils.PerformaceTest;
	import com.kvs.utils.RectangleUtil;
	
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import model.CoreFacade;
	
	import util.LayoutUtil;
	
	import view.element.ElementBase;
	import view.element.GroupElement;
	import view.interact.multiSelect.TemGroupElement;

	public final class ElementAutoLayerController
	{
		public function ElementAutoLayerController($coreMdt:CoreMediator)
		{
			coreMdt = $coreMdt;
		}
		
		/**
		 * 自动将元素排列至合适的层级并将元素以前的层级数组返回
		 */
		public function autoLayer(current:ElementBase):Vector.<int>
		{
			var layer:Vector.<int>;
			_indexChangeElement = null;
			if (enabled)
			{
				for each (var element:ElementBase in elements)
				{
					if (checkAutoLayerAvailable(current, element))
					{
						if (_indexChangeElement == null)
							_indexChangeElement = new Vector.<ElementBase>;
						_indexChangeElement.push(element);
					}
				}
				if (_indexChangeElement)
				{
					//当前元素放入层级比较队列
					_indexChangeElement.push(current);
					current = getLargestSizeElement(_indexChangeElement);
					_indexChangeElement.length = 0;
					for each (element in elements)
					{
						if (checkAutoLayerAvailable(current, element))
							_indexChangeElement.push(element);
					}
					_indexChangeElement.push(current);
					_indexChangeElement.sort(sortOnElementIndex);
					/*for each (element in _indexChangeElement)
						trace(element, element.index);*/
					layer = new Vector.<int>;
					for each (element in _indexChangeElement)
						layer.push(element.index);
					
					//获得一个重新比较后的顺序数组order
					var order:Vector.<int> = getOrderBySize(_indexChangeElement);
					//trace(order);
					//重新排列元素
					swapElements(_indexChangeElement, order);
				}
			}
			return layer;
		}
		
		/**
		 * 对element集合根据传入的order数组排列层级。 
		 * @param items
		 * @param order
		 * 
		 */
		public function swapElements(items:Vector.<ElementBase>, order:Vector.<int>):void
		{
			var layer:Vector.<int> = new Vector.<int>;
			var length:int = items.length;
			for (var i:int = 0; i < length; i++)
				layer[i] = items[i].index;
			
			for (i = 0; i < length - 1; i++)
			{
				if (order[i] == layer[i]) continue;
				for (var j:int = i + 1; j<length; j++)
				{
					if (order[i] == layer[j])
					{
						coreMdt.canvas.swapChildrenAt(layer[i], layer[j]);
						//元素位置已经变换，需要刷新layer
						for (var k:int = 0; k < length; k++)
							layer[k] = items[k].index;
						break;
					}
				}
			}
		}
		
		public function get indexChangeElement():Vector.<ElementBase>
		{
			return _indexChangeElement;
		}
		private var _indexChangeElement:Vector.<ElementBase>;
		
		private function get elements():Vector.<ElementBase>
		{
			return CoreFacade.coreProxy.elements;
		}
		
		private function getLargestSizeElement(items:Vector.<ElementBase>):ElementBase
		{
			if (items && items.length)
			{
				var element:ElementBase = items[0];
				var l:int = items.length;
				for (var i:int = 1; i < l; i++)
				{
					var aw:Number = items[i].scaledWidth;
					var ah:Number = items[i].scaledHeight;
					var bw:Number = element .scaledWidth;
					var bh:Number = element .scaledHeight;
					if (aw > bw && ah > bh)
						element = items[i];
				}
			}
			return element;
		}
		
		/**
		 * 根据传入的element集合按照尺寸重新排列层级，并返回一个层级数组。
		 * 
		 */
		private function getOrderBySize(items:Vector.<ElementBase>):Vector.<int>
		{
			var order:Vector.<ElementBase> = items.concat();
			var layer:Vector.<int> = new Vector.<int>;
			var l:int = items.length;
			sortOnElementLayer2(order);
			var dic:Dictionary = new Dictionary;
			for (var i:int = 0; i < l; i++)
				dic[order[i]] = items[i].index;
			for (i = 0; i < l; i++)
				layer[i] = dic[items[i]];
			return layer;
		}
		
		private function sortOnElementIndex(a:ElementBase, b:ElementBase):int
		{
			if (a.index < b.index)
				return -1;
			else if (a.index == b.index)
				return 0;
			else 
				return 1;
		}
		
		private function sortOnElementLayer2(vector:Vector.<ElementBase>):Vector.<ElementBase>
		{
			var l0:int = vector.length;
			var l1:int = l0 - 1;
			var rects:Vector.<Rectangle> = new Vector.<Rectangle>;
			for each (var element:ElementBase in vector)
				rects.push(LayoutUtil.getItemRect(coreMdt.canvas, element));
				
			for (var i:int = 0; i < l1; i++)
			{
				var arect:Rectangle = rects[i];
				for (var j:int = i + 1; j < l0; j++)
				{
					var brect:Rectangle = rects[j];
					if (arect.width < brect.width && arect.height < brect.height && 
						RectangleUtil.rectWithin(arect, brect))
					{
						var r:Rectangle = rects[i];
						rects[i] = rects[j];
						rects[j] = r;
						var t:ElementBase = vector[i];
						vector[i] = vector[j];
						vector[j] = t;
					}
				}
			}
			return vector;
		}
		
		private function checkAutoLayerAvailable(current:ElementBase, element:ElementBase):Boolean
		{
			var result:Boolean = false;
			if (current && current != element)
			{
				if (! (current is TemGroupElement) && ! (current is GroupElement) && ! current.grouped && 
					! (element is TemGroupElement) && ! (element is GroupElement) && ! element.grouped)
					result = overlappingElement(element, current);
			}
			return result;
		}
		
		private function overlappingElement(element:ElementBase, hitElement:ElementBase):Boolean
		{
			var erect:Rectangle = LayoutUtil.getItemRect(coreMdt.canvas, element);
			var hrect:Rectangle = LayoutUtil.getItemRect(coreMdt.canvas, hitElement);
			return RectangleUtil.rectOverlapping(erect, hrect);
		}
		
		public var enabled:Boolean = true;
		
		private var coreMdt:CoreMediator;
	}
}