package modules.pages.flash
{
	import com.kvs.utils.dec.NullPad;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	
	import org.osmf.net.ABRUtils;
	
	import util.LayoutUtil;
	
	import view.element.ElementBase;
	import view.interact.CoreMediator;
	import view.interact.interactMode.PageEditMode;
	
	/**
	 * 原件动画管理器，负责动画的添加，删除与编辑
	 */	
	public class FlasherHolder extends Sprite
	{
		public function FlasherHolder(ele:ElementBase, mdt:CoreMediator, editMode:PageEditMode)
		{
			super();
			
			this.ele = ele;
			this.mdt = mdt;
			this.edm = editMode;
			
			addChild(flasherIcon);
			unsetFlashIcon();
			
			this.ele.addEventListener(MouseEvent.ROLL_OVER, overEle, false, 0, true);
			this.ele.addEventListener(MouseEvent.ROLL_OUT, outEle, false, 0, true);
			this.ele.addEventListener(MouseEvent.CLICK, clickEle, false, 0, true);
		}
		
		/**
		 */		
		private var flasherIcon:FlasherIcon = new FlasherIcon;
		
		/**
		 */		
		private var edm:PageEditMode;
		
		/**
		 * 再次编辑时，唤醒 
		 * 
		 */		
		public function rework():void
		{
			if (flasher)
			{
				setFlasherIcon();
			}
		}
		
		/**
		 */		
		private function overEle(evt:MouseEvent):void
		{
			if (flasher)
			{
				
			}
			else
			{
				showTemIcon();
			}
		}
		
		/**
		 */		
		private function outEle(evt:MouseEvent):void
		{
			
			if (flasher)
			{
				
			}
			else
			{
				hideTemIcon();
			}
		}
		
		/**
		 */		
		private function clickEle(evt:MouseEvent):void
		{
			if (flasher)
			{
				this.flasher = null;
				unsetFlashIcon();
				
				edm.removeFlash(this);
				showTemIcon();
			}
			else
			{
				var f:Flasher = new Flasher();
				f.element = ele;
				f.elementID = ele.vo.id;
				
				this.flasher = f;
				
				hideTemIcon();
				edm.addFlash(this);
			}
		}
		
		/**
		 */		
		private function setFlasherIcon():void
		{
			flasherIcon.render(flasher.index.toString());
			flasherIcon.x = - this.w / 2 - flasherIcon.width;
			flasherIcon.visible = true;
		}
		
		/**
		 */		
		private function unsetFlashIcon():void
		{
			flasherIcon.visible = false;
			
			
		}
		
		/**
		 */		
		public function destroy():void
		{
			this.flasher = null;
			unsetFlashIcon();
		}
		
		/**
		 * 
		 * 鼠标划过入，临时显示动画图标
		 */		
		private function showTemIcon():void
		{
			graphics.clear();
			this.graphics.beginFill(0);
			this.graphics.drawCircle(0, 0, 10);
			graphics.endFill();
		}
		
		/**
		 * 鼠标划出时，隐藏临时图标
		 */		
		private function hideTemIcon():void
		{
			graphics.clear();
		}
		
		/**
		 */		
		public var flasher:Flasher;
		
		/**
		 */		
		public var ele:ElementBase;
		
		/**
		 */		
		private var mdt:CoreMediator;
		
		public var w:Number;
		public var h:Number;
	}
}