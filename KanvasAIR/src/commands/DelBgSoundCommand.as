package commands
{
	import flash.net.dns.AAAARecord;
	
	import model.CoreFacade;
	import model.SoundElment;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.MediatorNames;
	import view.themePanel.ThemePanelMediator;

	/**
	 * 
	 * @author wanglei
	 * 
	 */	
	public class DelBgSoundCommand extends Command
	{
		public function DelBgSoundCommand()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			this.sound = CoreFacade.coreProxy.sound;
			CoreFacade.coreProxy.sound = null;
			
			themePanel = facade.retrieveMediator(MediatorNames.THEME_PANEL) as ThemePanelMediator;
			themePanel.toNormal();
			
			UndoRedoMannager.register(this);
			this.dataChanged();
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			CoreFacade.coreProxy.sound = this.sound;
			themePanel.toInserted();
			
			this.dataChanged();
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			CoreFacade.coreProxy.sound = null;
			themePanel.toNormal();
			
			this.dataChanged();
		}
		
		/**
		 */		
		private var themePanel:ThemePanelMediator;
		
		/**
		 */		
		private var sound:SoundElment;
		
		
	}
}