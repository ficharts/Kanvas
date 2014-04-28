package commands
{
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.MediatorNames;
	import view.interact.CoreMediator;
	
	/**
	 * 撤销指令
	 */
	public class UnDoCMD extends Command
	{
		public function UnDoCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			// 先取消选择，防止元素状态紊乱，导致不能被选择
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			UndoRedoMannager.unDo();
		}
	}
}