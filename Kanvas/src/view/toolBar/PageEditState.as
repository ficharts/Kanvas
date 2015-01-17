package view.toolBar
{
	import com.kvs.ui.button.LabelBtn;
	import com.kvs.ui.label.LabelUI;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 页面动画效果编辑时的工具条
	 */	
	public class PageEditState extends ToolBarStateBS
	{
		public function PageEditState(toolbar:ToolBar)
		{
			super(toolbar);
		}
		
		/**
		 */		
		override public function init():void
		{
			this.ctner.visible = false;
			
			title.text = "点击图片，文字，图形，为其添加/删除动画效果";
			title.styleXML = <label radius='0' vPadding='5' hPadding='5'>
									<format color='#eeeeee' font='微软雅黑' size='12'/>
								  </label>
			title.render();
			this.ctner.addChild(title);
			
			
			//确定按钮
			confirmBtn.text = "确定";
			confirmBtn.bgStyleXML = <states>
										<normal>
											<fill color='#1b7ed1' alpha='1'/>
										</normal>
										<hover>
											<fill color='#68a9df' alpha='1'/>
										</hover>
										<down>
											<fill color='#105995' alpha='1' angle="90"/>
										</down>
									</states>
				
			confirmBtn.labelStyleXML = <label vAlign="center" vPadding='8'>
							                <format color='ffffff' font='微软雅黑' size='12' letterSpacing="3"/>
							            </label>
				
			confirmBtn.render();
			this.ctner.addChild(confirmBtn);
			confirmBtn.addEventListener(MouseEvent.CLICK, confirmEdit);
			
			//取消按钮
			cancelBtn.bgStyleXML = <states>
										<normal>
											<fill color='#333333' alpha='1'/>
										</normal>
										<hover>
											<fill color='#111111' alpha='1'/>
										</hover>
										<down>
											<fill color='#000000' alpha='1' angle="90"/>
										</down>
									</states>
				
			cancelBtn.labelStyleXML = <label vAlign="center" vPadding='8'>
							                <format color='ffffff' font='微软雅黑' size='12' letterSpacing="3"/>
							            </label>
				
			cancelBtn.text = "取消";
			this.ctner.addChild(cancelBtn);
			
			cancelBtn.addEventListener(MouseEvent.CLICK, cancelEdit);
			
			
			//清除动画按钮
			clearBtn.bgStyleXML = cancelBtn.bgStyleXML;
			clearBtn.labelStyleXML = cancelBtn.labelStyleXML;
			clearBtn.text = "重设动画";
			this.ctner.addChild(clearBtn);
			clearBtn.addEventListener(MouseEvent.CLICK, clearFlashesHandler);
		}
		
		/**
		 */		
		private function clearFlashesHandler(evt:MouseEvent):void
		{
			tb.main.mainNavControl.clearFlashesInPage();
		}
		
		/**
		 */		
		private function cancelEdit(evt:Event):void
		{
			tb.main.mainNavControl.cancelPageEdit();
		}
		
		/**
		 */		
		private function confirmEdit(evt:Event):void
		{
			tb.main.mainNavControl.confirmPageEdit();
		}
		
		/**
		 */		
		override public function updateLayout():void
		{
			tb.renderBG();
			
			title.x = (tb.w - title.width) / 2;
			title.y = (tb.h - title.height) / 2;
			
			
			confirmBtn.x = tb.w - confirmBtn.width - 20;
			cancelBtn.y = clearBtn.y = confirmBtn.y = (tb.h - confirmBtn.height) / 2;
			
			cancelBtn.x = 20;
			clearBtn.x = cancelBtn.x + cancelBtn.width + 10;
		}
		
		/**
		 */		
		private var title:LabelUI = new LabelUI;
		
		/**
		 */		
		internal var confirmBtn:LabelBtn = new LabelBtn();
		
		/**
		 */		
		internal var cancelBtn:LabelBtn = new LabelBtn();
		
		/**
		 */		
		internal var clearBtn:LabelBtn = new LabelBtn();
		
		/**
		 */		
		override public function toNomal():void
		{
			tb.currentState.ctner.visible = false;
			
			tb.currentState = tb.normalState;
			tb.currentState.ctner.visible = true;
		}
	}
}