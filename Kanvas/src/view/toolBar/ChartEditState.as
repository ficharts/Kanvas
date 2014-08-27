package view.toolBar
{
	import com.kvs.ui.button.LabelBtn;
	import com.kvs.ui.label.LabelUI;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import model.CoreFacade;

	/**
	 *
	 * 图表编辑的工具条
	 *  
	 * @author wanglei
	 * 
	 */	
	public class ChartEditState extends ToolBarStateBS
	{
		public function ChartEditState(toolbar:ToolBar)
		{
			super(toolbar);
		}
		
		/**
		 */		
		override public function init():void
		{
			this.ctner.visible = false;
			
			title.text = "图表编辑";
			title.styleXML = <label radius='0' vPadding='5' hPadding='5'>
									<format color='#eeeeee' font='微软雅黑' size='12'/>
								  </label>
			title.render();
			this.ctner.addChild(title);
			
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
			
			cancelBtn.addEventListener(MouseEvent.CLICK, cancelChartEdit);
			confirmBtn.addEventListener(MouseEvent.CLICK, confirmChartEdit);
			
			tb.main.kvsCore.addEventListener(KVSEvent.TOOLBAR_TO_CHART, toChartEditHandler);
			tb.main.kvsCore.addEventListener(KVSEvent.TOOLBAR_TO_NORMAL, toNormalHandler);
		}
		
		/**
		 */		
		private function toNormalHandler(evt:KVSEvent):void
		{
			tb.main.mainNavControl.toNormal();
		}
		
		/**
		 */		
		private function toChartEditHandler(evt:KVSEvent):void
		{
			tb.main.mainNavControl.toChartEditMode();
		}
		
		/**
		 */		
		private function cancelChartEdit(evt:Event):void
		{
			tb.main.mainNavControl.toNormal();
		}
		
		/**
		 */		
		private function confirmChartEdit(evt:Event):void
		{	
			tb.main.kvsCore.applyTextToChart();
			tb.main.mainNavControl.toNormal();
		}
		
		/**
		 */		
		override public function updateLayout():void
		{
			tb.renderBG();
			
			title.x = (tb.w - title.width) / 2;
			title.y = (tb.h - title.height) / 2;
			
			
			confirmBtn.x = tb.w - confirmBtn.width - 20;
			cancelBtn.y = confirmBtn.y = (tb.h - confirmBtn.height) / 2;
			
			cancelBtn.x = 20;
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
		override public function toNomal():void
		{
			tb.currentState.ctner.visible = false;
			
			tb.currentState = tb.normalState;
			tb.currentState.ctner.visible = true;
			
			tb.main.pagePanel.visible = true;
		}
		
	}
}