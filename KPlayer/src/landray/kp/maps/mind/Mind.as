package landray.kp.maps.mind
{
	import landray.kp.maps.mind.core.mm_internal;
	import landray.kp.maps.mind.event.MindToolEvent;
	import landray.kp.maps.mind.model.TreeElementVO;
	import landray.kp.maps.mind.utils.MindMapUtil;
	import landray.kp.maps.mind.view.Layer;
	import landray.kp.maps.mind.view.TreeElement;
	import landray.kp.view.Graph;
	

	public class Mind extends Graph
	{
		use namespace mm_internal;
		
		public function Mind()
		{
			super();
			initialize();
		}
		
		override public function flashTrek():void
		{
			for each (var element:TreeElement in allChild)
				element.render(viewer.canvas.scaleX);
		}
		
		private function initialize():void
		{
			allChild = new Vector.<TreeElement>;
			mindData = new MindData;
			viewer.canvas.addChild(lineLayer = new Layer);
			viewer.canvas.addChild(itemLayer = new Layer);
			lineLayer.mouseEnabled = lineLayer.mouseChildren = false;
			itemLayer.mouseEnabled = false;
		}
		
		private function creatMind(arr:Vector.<TreeElementVO>, elementFather:TreeElement):void
		{
			for (var i:int = 0; i < arr.length; i++) 
			{	
				var vo:TreeElementVO = arr[i];
				if (vo.level < 3)
				{
					MindMapUtil.updateTreeElementVODirection(vo);
				}
				else
				{
					vo.hDirection = vo.father.hDirection;
					vo.vDirection = vo.father.vDirection;
				}
				var treeElement:TreeElement = new TreeElement(vo);
				treeElement.render();
				
				//首先添加到显示列表是为了解决三级元素高度计算不准确的问题
				treeElement.visible = false;
				itemLayer.addChild(treeElement);
				
				if (vo.father == null)
				{
					MindData.NodeTreeElement = treeElement;
				}
				else
				{
					elementFather.childs.push(treeElement);
					treeElement.father = elementFather;
					treeElement.vo.line.startElement = treeElement.father;
					treeElement.vo.line.endElement = treeElement;
				}
				if (vo.children && vo.children.length)
				{
					treeElement.addEventListener(MindToolEvent.EXPAND, updateMindHandler);
					treeElement.addEventListener(MindToolEvent.MERGER, updateMindHandler);
					creatMind(vo.children, treeElement);
				}
			}
		}
		
		/**
		 * 清空所有子元素
		 **/
		private function clearAllChild():void
		{
			while (itemLayer.numChildren) itemLayer.removeChildAt(0);
			allChild.length = 0;
		}
		
		private function updateMindHandler(event:MindToolEvent):void
		{
			clearAllChild();
			layoutMind();
			flashTrek();
		}
		/**
		 * 布局思维导图
		 **/
		private function layoutMind():void
		{
			MindData.NodeTreeElement.visible = true;
			itemLayer.addChild(MindData.NodeTreeElement);
			allChild.push(MindData.NodeTreeElement);
			
			if (MindData.NodeTreeElement.vo.expand)
				layoutChild(MindData.NodeTreeElement.childs);
			lineLayer.graphics.clear();
			layoutLines(MindData.NodeTreeElement.childs);
		}
		
		private function layoutChild(childs:Vector.<TreeElement>):void
		{
			var last:Object = {};
			for each (var item:TreeElement in childs) 
			{
				item.visible = true;
				itemLayer.addChild(item);
				
				allChild.push(item);
				var h:int = (item.vo.hDirection == "left") ? -1 : 1;
				var v:int = (item.vo.vDirection == "top" ) ? -1 : 1;
				
				item.x = item.father.x + ((MindMapUtil.getElementWidth(item.father) + MindMapUtil.getElementWidth(item)) * .5) * h;
				if(!last[h]) last[h] = {};
				var father:Boolean = (!last[h][v]);
				last[h][v] = (father) ? item.father : last[h][v];
				item.y = last[h][v].y + (MindMapUtil.getElementHeight(last[h][v], ! father) + MindMapUtil.getElementHeight(item)) * .5 * v;
				last[h][v] = item;
				
				if(item.vo.expand)
					layoutlastChild(item.childs);
			}
		}
		
		private function layoutlastChild(childs:Vector.<TreeElement>):void
		{
			var last:TreeElement;
			for each (var item:TreeElement in childs) 
			{
				item.visible = true;
				itemLayer.addChild(item);
				
				allChild.push(item);
				var h:int = (item.vo.hDirection == "left") ? -1 : 1;
				var v:int = (item.vo.vDirection == "top" ) ? -1 : 1;
				
				item.x = item.father.x + ((MindMapUtil.getElementWidth(item.father) + MindMapUtil.getElementWidth(item)) * .5) * h;
				var father:Boolean = (last == null);
				last = (father) ? item.father : last;
				item.y = last.y + (MindMapUtil.getElementHeight(item) + MindMapUtil.getElementHeight(last) * ((father) ? -1 : 1)) * .5;
				last = item;
				
				if(item.vo.expand)
					layoutlastChild(item.childs);
			}	
		} 
		
		private function layoutLines(childs:Vector.<TreeElement>):void
		{
			if (childs && childs.length > 0 && childs[0].father.vo.expand)
			{
				for each (var item:TreeElement in childs) 
				{
					item.vo.line.startX = MindMapUtil.getElementLineStartX(item.father);
					item.vo.line.startY = MindMapUtil.getElementLineStartY(item.father);
					item.vo.line.endX   = MindMapUtil.getElementLineEndX  (item);
					item.vo.line.endY   = MindMapUtil.getElementLineEndY  (item);
					MindMapUtil.renderLine(lineLayer.graphics, item.vo.line);
					layoutLines(item.childs);
				}
			}
		}
		
		/**
		 * 设置思维导图数据
		 **/
		override public function set dataProvider(value:XML):void
		{
			mindData.mindDataMapping(value);
			creatMind(MindData.allTreeElementVOs, null);
			layoutMind();
		}
		
		/**
		 * 所有子元素
		 **/
		private var allChild:Vector.<TreeElement>;
		
		private var mindData:MindData;
		
		private var lineLayer:Layer;
		
		private var itemLayer:Layer;
	}
}