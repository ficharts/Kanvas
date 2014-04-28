package view.interact
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import model.vo.PageVO;
	
	import util.LayoutUtil;
	
	import view.ui.ICanvasLayout;
	import view.ui.IMainUIMediator;

	/**
	 * 
	 * @author wallenMac
	 * 
	 * 控制预览模式下/kplayer中元素点击时的镜头缩放
	 * 
	 */	
	public class PreviewClicker implements IClickMove
	{
		public function PreviewClicker(mdt:IMainUIMediator)
		{
			this.mdt = mdt;
			
			clickControl = new ClickMoveControl(this, mdt.mainUI.canvas);
		}
		
		/**
		 * 当鼠标按下对象，没有拖动就释放时触发此方法
		 */		
		public function clicked():void
		{
			if (enable)
			{
				var element:ICanvasLayout;
				var elements:Vector.<ICanvasLayout> = mdt.mainUI.canvas.elements;
				elementsHit.length = pagesHit.length = 0;
				
				//先将碰撞的原件放到一起，然后在从里面挑选出最符合要求的
				for each (element in elements)
				{
					var bound:Rectangle = LayoutUtil.getItemRect(mdt.mainUI.canvas, element);
					if (bound.contains(mdt.mainUI.stage.mouseX, mdt.mainUI.stage.mouseY))
					{
						elementsHit.push(element);
						
						if (element["vo"] is PageVO)
							pagesHit.push(element);
					}
					/*if (element.shape.hitTestPoint(mdt.mainUI.stage.mouseX, mdt.mainUI.stage.mouseY, true))
					{
						elementsHit.push(element);
						
						if (element.vo is PageVO)
							pagesHit.push(element);
					}*/
				}
				
				//选出最适合缩放的原件
				if (elementsHit.length)
				{
					var targetElement:ICanvasLayout;
					for each (element in elementsHit)
					{
						if (targetElement == null)
						{
							targetElement = element;
						}
						else
						{
							//尺寸小的元素优先
							if (getSize(element) < getSize(targetElement) && element.index > targetElement.index)
								targetElement = element;
						}
					}
					
					mdt.zoomElement(targetElement["vo"]);
					
					
					//点击区域的最小尺寸页面 ＝ 当前页面
					var nearPage:ICanvasLayout;//离点击区域最近的页面元素
					for each (element in pagesHit)
					{
						if (nearPage == null)
						{
							nearPage = element;
						}
						else
						{
							//尺寸小的元素优先
							if (getSize(element) < getSize(nearPage))
								nearPage = element;
						}
					}
					
					if (nearPage)
						mdt.setPageIndex((nearPage["vo"] as PageVO).index);
				}
				else
				{
					mdt.zoomAuto();
				}
				
			}
		}
		
		/**
		 * 以最小尺寸为标准
		 */		
		private function getSize(element:ICanvasLayout):Number
		{
			var w:Number = (element as ICanvasLayout).scaledWidth;
			var h:Number = (element as ICanvasLayout).scaledHeight;
			
			return w * h;
		}
		
		/**
		 * 获取原件的现实层级
		 */		
		private function getIndex(element:ICanvasLayout):int
		{
			return mdt.mainUI.canvas.getChildIndex(element as DisplayObject);
		}
		
		/**
		 * 点击碰撞到的元素
		 */		
		private var elementsHit:Vector.<ICanvasLayout> = new Vector.<ICanvasLayout>;
		
		/**
		 * 点击碰撞到的页面
		 */		
		private var pagesHit:Vector.<ICanvasLayout> = new Vector.<ICanvasLayout>;
		
		/**
		 */		
		public function startMove():void
		{
		}
			
		/**
		 */			
		public function stopMove():void
		{
		}
		
		/**
		 */		
		public function moveOff(xOff:Number, yOff:Number):void
		{
			
		}
		
		/**
		 */		
		private var clickControl:ClickMoveControl;
		
		/**
		 * 开启后，才会处理点击交互
		 */		
		private var _enable:Boolean = false;
		
		/**
		 */		
		private var mdt:IMainUIMediator;

		/**
		 *  
		 */
		public function get enable():Boolean
		{
			return _enable;
		}

		/**
		 * @private
		 */
		public function set enable(value:Boolean):void
		{
			_enable = value;
		}
		
	}
}