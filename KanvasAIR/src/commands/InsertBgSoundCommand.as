package commands
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	
	import model.CoreFacade;
	import model.SoundElment;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.MediatorNames;
	import view.themePanel.ThemePanelMediator;

	/**
	 */	
	public class InsertBgSoundCommand extends Command
	{
		public function InsertBgSoundCommand()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			musicFile = new File;
			musicFile.browse([new FileFilter("音乐文件", "*.mp3")]);
			musicFile.addEventListener(Event.SELECT, fileSelected);
			
			themePanel = facade.retrieveMediator(MediatorNames.THEME_PANEL) as ThemePanelMediator;
			
			
		}
		
		/**
		 */		
		private var themePanel:ThemePanelMediator;
		
		/**
		 */		
		private function fileSelected(evt:Event):void
		{
			CoreFacade.coreProxy.sound = new SoundElment;
			CoreFacade.coreProxy.sound.insertSound(musicFile.url, musicFile.name);
			
			this.sound = CoreFacade.coreProxy.sound;
			themePanel.toInserted();
			
			UndoRedoMannager.register(this);
			this.dataChanged();
		}
		
		/**
		 */		
		override public function undoHandler():void
		{
			CoreFacade.coreProxy.sound = null;
			themePanel.toNormal();
			
			this.dataChanged();
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			CoreFacade.coreProxy.sound = this.sound;
			themePanel.toInserted();
			
			this.dataChanged();
		}
		
		/**
		 */		
		private var sound:SoundElment;
		
		/**
		 */		
		private var musicFile:File;
	}
}