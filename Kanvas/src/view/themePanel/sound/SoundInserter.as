package view.themePanel.sound
{
	import com.kvs.ui.button.LabelBtn;
	
	import commands.Command;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import view.themePanel.ThemePanel;
	
	/**
	 */	
	public class SoundInserter extends Sprite
	{
		public function SoundInserter(themePanel:ThemePanel)
		{
			super();
			
			this.themePanel = themePanel;
			
			insertBtn.text = "插入背景音乐";
			delBtn.text = "删除背景音乐";
			delBtn.visible = false;
			
			insertBtn.bgStyleXML = <states>
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
				
			insertBtn.labelStyleXML =  <label vAlign="center" vPadding='8'>
							                <format color='ffffff' font='微软雅黑' size='12' letterSpacing="3"/>
							            </label>
				
			delBtn.labelStyleXML = <label vAlign="center" vPadding='8'>
							                <format color='ffffff' font='微软雅黑' size='12' letterSpacing="3"/>
							            </label>
				
			delBtn.bgStyleXML = <states>
										<normal>
											<fill color='#ff0000' alpha='1'/>
										</normal>
										<hover>
											<fill color='#ff5555' alpha='1'/>
										</hover>
										<down>
											<fill color='#ee0000' alpha='1' angle="90"/>
										</down>
									</states>
			
			delBtn.addEventListener(MouseEvent.CLICK, delSound);
			insertBtn.addEventListener(MouseEvent.CLICK, insertSound);
			
			insertBtn.w = delBtn.w = 130;
			
			addChild(insertBtn);
			addChild(delBtn);
		}
		
		/**
		 */		
		private var themePanel:ThemePanel;
		
		/**
		 */		
		private function delSound(evt:MouseEvent):void
		{
			themePanel.kvs.kvsCore.facade.sendNotification(Command.DEL_BG_MUSIC);
		}
		
		/**
		 */		
		private function insertSound(evt:MouseEvent):void
		{
			themePanel.kvs.kvsCore.facade.sendNotification(Command.INSERT_BG_MUSIC);
		}
		
		/**
		 */		
		private var insertBtn:LabelBtn = new LabelBtn;
		
		/**
		 */		
		private var delBtn:LabelBtn = new LabelBtn;
		
		/**
		 */		
		public function toNormal():void
		{
			delBtn.visible = false;
			insertBtn.visible = true;
		}
		
		/**
		 */		
		public function toInserted():void
		{
			delBtn.visible = true;
			insertBtn.visible = false;
		}
	}
}