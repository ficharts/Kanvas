package commands
{
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;

	public class ReDoCMD extends Command
	{
		public function ReDoCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			// 先取消选择，防止元素状态紊乱，导致不能被选择
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			UndoRedoMannager.redo();
		}
	}
}