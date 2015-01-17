package modules.pages.flash
{
	import com.kvs.ui.button.LabelBtn;
	import com.kvs.utils.Map;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import modules.pages.flash.btns.ChartFlashBtn;
	import modules.pages.flash.btns.DeflateBtn;
	import modules.pages.flash.btns.EnlargeBtn;
	import modules.pages.flash.btns.FadeInBtn;
	import modules.pages.flash.btns.FadeOutBtn;
	import modules.pages.flash.btns.FallBtn;
	import modules.pages.flash.btns.FlashBtnBS;
	import modules.pages.flash.btns.FlashFromLeftBtn;
	import modules.pages.flash.btns.RiseBtn;
	import modules.pages.flash.btns.RoteBtn;
	
	import view.element.ElementBase;
	import view.element.chart.IChartElement;
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
			
			addChild(shapeProxy);
			
			temIcon = new Bitmap(new flash_b);
			temIcon.width = temIcon.height = 20;
			temIcon.smoothing = true;
			temIcon.visible = false;
			addChild(temIcon);
			
			addChild(flasherIcon);
			unsetFlashIcon();
			
			this.addEventListener(MouseEvent.ROLL_OVER, overEle, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, outEle, false, 0, true);
			this.shapeProxy.addEventListener(MouseEvent.CLICK, clickEle, false, 0, true);
			
			initFlashBtns();
		}
		
		/**
		 */		
		public function render():void
		{
			var dis:uint = 10;
			
			//绘制鼠标交互区域
			shapeProxy.graphics.clear();
			shapeProxy.graphics.beginFill(0, 0);
			
			//高度增高了是为了防止鼠标移出原件区域时，淡出工具条消失
			shapeProxy.graphics.drawRect( - this.w / 2, - this.h / 2 - dis * 2, this.w, this.h + dis * 2);
			shapeProxy.graphics.endFill();
			
			var gap:uint = 3;
			btnsCtner.graphics.clear();
			var w:Number = btnsCtner.width + gap;
			var h:Number = btnsCtner.height//btnsCtner.height;
			
			//绘制箭头
			btnsCtner.graphics.beginFill(0x555555);
			btnsCtner.graphics.moveTo(w / 2, h + dis);
			btnsCtner.graphics.lineTo(w / 2 - dis, h);
			btnsCtner.graphics.lineTo(w / 2 + dis, h);
			btnsCtner.graphics.lineTo(w / 2, h + dis);
			btnsCtner.graphics.endFill();
			
			 //绘制按钮背景
			btnsCtner.graphics.beginFill(0x555555);
			btnsCtner.graphics.drawRoundRect( - gap, - gap, w + gap * 2, h + gap * 2, 3, 3);
			btnsCtner.graphics.endFill();
				
			btnsCtner.x = - w / 2;
			btnsCtner.y = (- this.h / 2 - h) - dis - 5;
			
			
			var btns:Array = flashBtns.values();
			for each (var btn:FlashBtnBS in btns)
				btn.disSelect();
		}
		
		/**
		 */		
		private var curFlashBtn:FlashBtnBS;
		
		/**
		 * 
		 */		
		private var shapeProxy:Sprite = new Sprite;
		
		/**
		 * 初始化动画按钮
		 */		
		private function initFlashBtns():void
		{
			initBtn(new FadeInBtn(this));
			initBtn(new FlashFromLeftBtn(this));
			initBtn(new EnlargeBtn(this));
			initBtn(new DeflateBtn(this));
			initBtn(new RoteBtn(this));
			initBtn(new FallBtn(this));
			initBtn(new RiseBtn(this));
			
			
			initBtn(new FadeOutBtn(this));
			
			if (ele is IChartElement)
				initBtn(new ChartFlashBtn(this));
			
			btnsCtner.visible = false;
			addChild(btnsCtner);
			btnsCtner.addEventListener(MouseEvent.CLICK, flashBtnClicked);
		}
		
		/**
		 */		
		private function initBtn(btn:FlashBtnBS):void
		{
			btn.minWidth = 30;
			btn.h = 26;
			btn.labelStyleXML = <label vAlign="center" hpadding='0'>
									<format color='ffffff' font='微软雅黑' size='12' letterSpacing="3"/>
								</label>
			
			btn.bgStyleXML = <states radius='2'>
								<normal radius='2'>
									<fill color='#1b7ed1' alpha='0'/>
								</normal>
								<hover>
									<fill color='#68a9df' alpha='1'/>
								</hover>
								<down>
									<fill color='#ff9999' alpha='1' angle="90"/>
								</down>
							</states>
				
			btn.x = btnsCtner.width + 2;
			btn.render();
			btnsCtner.addChild(btn);
			
			flashBtns.put(btn.key, btn);
		}
		
		
		/**
		 */		
		private var chartBtn:LabelBtn = new LabelBtn;
		
		/**
		 */		
		private var btnsCtner:Sprite = new Sprite;
			
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
				setFlasherIcon();
			else
				unsetFlashIcon();
		}
		
		/**
		 */		
		private function flashBtnClicked(evt:MouseEvent):void
		{
			if (evt.target is LabelBtn)
			{
				if (curFlashBtn && evt.target != curFlashBtn)
				{
					curFlashBtn.disSelect();
					
					this.flasher = null;
					edm.removeFlash(this);
				}
				
				curFlashBtn = evt.target as FlashBtnBS;
				curFlashBtn.selected();
				
				var f:IFlash = curFlashBtn.flash;
				f.element = ele;
				f.elementID = ele.vo.id;
				
				this.flasher = f;
				
				hideTemIcon();
				edm.addFlash(this);
			}
			
		}
		
		/**
		 */		
		private function overEle(evt:MouseEvent):void
		{
			if (!flasher)
				showTemIcon();
			
			btnsCtner.visible = true;
		}
		
		/**
		 */		
		private function outEle(evt:MouseEvent):void
		{
			if (!flasher)
				hideTemIcon();
			
			btnsCtner.visible = false;
		}
		
		/**
		 * 点击原件，默认被添加的动画
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
				var f:IFlash;
				var btns:Array = flashBtns.values();
				if (ele is IChartElement)
					curFlashBtn = btns[flashBtns.size - 1];
				else
					curFlashBtn = btns[0];
				
				f = curFlashBtn.flash;
				curFlashBtn.selected();
				
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
			flasherIcon.x = - this.w / 2 - flasherIcon.width - 5;
			flasherIcon.y =  - flasherIcon.height / 2;
			flasherIcon.visible = true;
			
			setFlashBtn();
		}
		
		/**
		 */		
		private function setFlashBtn():void
		{
			if (curFlashBtn && curFlashBtn.isSelect)
				curFlashBtn.disSelect();
			
			curFlashBtn = flashBtns.getValue(flasher.key) as FlashBtnBS;
			curFlashBtn.selected();
		}
		
		/**
		 */		
		private var flashBtns:Map = new Map
		
		/**
		 */		
		private function unsetFlashIcon():void
		{
			flasherIcon.visible = false;
			
			if (curFlashBtn)
				curFlashBtn.disSelect();
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
			temIcon.x = - this.w / 2 - temIcon.width;
			temIcon.y =  - temIcon.height / 2;
			temIcon.visible = true;
		}
		
		/**
		 * 鼠标划出时，隐藏临时图标
		 */
		private function hideTemIcon():void
		{
			temIcon.visible = false;
		}
		
		/**
		 */		
		private var temIcon:Bitmap;
		
		/**
		 */		
		public var flasher:IFlash;
		
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