package view.interact
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import model.vo.ElementVO;
	import model.vo.PageVO;
	
	import util.LayoutUtil;
	
	import view.interact.zoomMove.GestureControl;
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
			mdt.mainUI.canvas.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);

		}
		
		/**
		 * 当鼠标按下对象，没有拖动就释放时触发此方法
		 */		
		public function clicked():void
		{
			if (enable && !GestureControl.gestureControl)
			{
				if (mdt.pages.length && mdt.mainUI.stage.mouseX < 150 || mdt.mainUI.stage.mouseX > (mdt.mainUI.stage.stageWidth - 150))
				{
					if (mdt.mainUI.stage.mouseX < 150)
					{
						if (mdt.mainUI.stage.mouseX > 100 || mdt.mainUI.stage.mouseY < (mdt.mainUI.stage.stageHeight - 100))
						{
							try{
								Object(mdt.mainUI).interact.show(0, 0, 150, mdt.mainUI.stage.stageHeight);
							} catch (e:Error) { }
							callLater(mdt.pages.prev);
							//mdt.pages.prev();
						}
					}
					else
					{
						try{
							Object(mdt.mainUI).interact.show((mdt.mainUI.stage.stageWidth - 150), 0, 150, mdt.mainUI.stage.stageHeight);
						} catch (e:Error) { }
						callLater(mdt.pages.next);
						//mdt.pages.next();
					}
				}
				else
				{
					var element:ICanvasLayout;
					var elements:Vector.<ICanvasLayout> = mdt.mainUI.canvas.elements;
					elementsHit.length = pagesHit.length = 0;
					
					//先将碰撞的原件放到一起，然后在从里面挑选出最符合要求的
					for each (element in elements)
					{
						var bound:Rectangle = LayoutUtil.getItemRect(mdt.mainUI.canvas, element);
						
						if (Object(element).canvas.alpha >= 1 && bound.width > 20 && bound.height > 20 &&　bound.contains(mdt.mainUI.stage.mouseX, mdt.mainUI.stage.mouseY))
						{
							elementsHit.push(element);
							
							if (element.isPage)
								pagesHit.push(element);
						}
					}
					
					callLater(viewHit);
				}
			}
		}
		
		private function viewHit():void
		{
			if (elementsHit.length)
			{
				elementsHit.sort(sortOnSize);
				var targetElement:ICanvasLayout = elementsHit[0];
				
				//点击区域的最小尺寸页面 ＝ 当前页面
				if (pagesHit.length)
				{
					//离点击区域最近的页面元素
					pagesHit.sort(sortOnSize);
					var nearPage:ICanvasLayout = pagesHit[0];
					mdt.setPageIndex((nearPage["vo"].pageVO).index);
					//mdt.zoomElement(nearPage["vo"]);
				}
				else
				{
					//mdt.zoomElement(targetElement["vo"]);
				}
				mdt.zoomElement(targetElement["vo"]);
			}
		}
		
		private function doubleClickHandler(evt:MouseEvent):void
		{
			if (enable && !GestureControl.gestureControl)
			{
				callCancel();
				var element:ICanvasLayout;
				var elements:Vector.<ICanvasLayout> = mdt.mainUI.canvas.elements;
				elementsHit.length = pagesHit.length = 0;
				
				//先将碰撞的原件放到一起，然后在从里面挑选出最符合要求的
				for each (element in elements)
				{
					var bound:Rectangle = LayoutUtil.getItemRect(mdt.mainUI.canvas, element);
					if (bound.width > 20 && bound.height > 20 &&　bound.contains(mdt.mainUI.stage.mouseX, mdt.mainUI.stage.mouseY))
					{
						elementsHit.push(element);
						
						if (element.isPage)
							pagesHit.push(element);
					}
				}
				//选出最适合缩放的原件
				if (elementsHit.length)
				{
					elementsHit.sort(sortOnSize);
					var targetElement:ICanvasLayout;
					var screenSize:Number = mdt.mainUI.bound.width * mdt.mainUI.bound.height;
					var multiple:Number = Math.pow(mdt.mainUI.canvas.scaleX, 2);
					for each (element in elementsHit)
					{
						
						//尺寸小的元素优先
						if (getSize(element["vo"]) * multiple > screenSize)
						{
							targetElement = element;
							break;
						}
						
					}
					
					//点击区域的最小尺寸页面 ＝ 当前页面
					var nearPage:ICanvasLayout;//离点击区域最近的页面元素
					pagesHit.sort(sortOnSize);
					for each (element in pagesHit)
					{
						if (getSize(element["vo"]) * multiple > screenSize)
						{
							nearPage = element;
							break;
						}
					}
					
					if (nearPage)
					{
						mdt.setPageIndex((nearPage["vo"].pageVO).index);
						mdt.zoomElement(nearPage["vo"]);
					}
					else
					{
						if (targetElement)
							mdt.zoomElement(targetElement["vo"]);
						else
							mdt.zoomAuto();
					}
				}
				else
				{
					mdt.zoomAuto();
				}
			}
		}
		
		private function callLater(op:Function):void
		{
			if (!timer)
			{
				operation = op;
				timer = new Timer(300, 1);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
				timer.start();
			}
		}
		
		private function callCancel():void
		{
			if (timer)
			{
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
				timer = null;
				operation = null;
			}
		}
		
		private function timerComplete(e:Event):void
		{
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			timer = null;
			if (operation != null) 
			{
				operation();
			}
		}
		
		private var timer:Timer;
		
		
		/**
		 * 以最小尺寸为标准
		 */		
		private function getSize(element:ElementVO):Number
		{
			if (element)
			{
				var w:Number = element.width  * element.scale;
				var h:Number = element.height * element.scale;
			}
			else
			{
				w = h = 0;
			}
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
		public function startDragMove():void
		{
		}
			
		/**
		 */			
		public function stopDragMove():void
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
		
		public function clearHistory():void
		{
			history.length = 0;
		}
		
		private function sortOnSize(a:Object, b:Object):int
		{
			var sizea:Number = getSize(a.vo);
			var sizeb:Number = getSize(b.vo);
			if (sizea < sizeb)
				return -1;
			else if (sizea == sizeb)
				return 0;
			else 
				return 1;
		}
		
		
		private var history:Array = [];
		
		private var operation:Function;
	}
}