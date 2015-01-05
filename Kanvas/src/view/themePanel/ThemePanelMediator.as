package view.themePanel
{
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * 
	 */	
	public class ThemePanelMediator extends Mediator
	{
		public function ThemePanelMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		/**
		 */		
		public function toInserted():void
		{
			themePanel.sound.toInserted();
		}
		
		/**
		 */		
		public function toNormal():void
		{
			themePanel.sound.toNormal();
		}
		
		/**
		 */		
		private function get themePanel():ThemePanel
		{
			return viewComponent as ThemePanel;
		}
	}
}