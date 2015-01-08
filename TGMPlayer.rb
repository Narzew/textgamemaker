$tgm_player_version = 0.01
$tgm_player_reldate = "07.04.2012"

def sel
	return "============================================================\n"
end

module TGM
	
	def self.start
		$scenes = []
		$switches = []
		$variables = []
		$userdb = []
		$gamedb = []
		$act_scene = 1
		TGM.make_header
	end
	
	def self.make_header
		print "#{sel}**Text Game Maker\n**Game Player\n**by Narzew\n**v #{$tgm_player_version}\n**Release Date : #{$tgm_player_reldate}\n**All rights reserved.\n#{sel}\n\n\n"
	end
	
	def self.scenes_size
		return $scenes.size
	end
	
	def self.scene(x,y)
		$scenes[x] = y
	end
	
	def self.call_command(x)
		$args = x[1]
		case x[0]
		when 0 then TGM::Command.goto
		when 1 then TGM::Command.msg
		when 2 then TGM::Command.get_switch
		when 3 then TGM::Command.set_switch
		when 4 then TGM::Command.get_variable
		when 5 then TGM::Command.set_variable
		when 6 then TGM::Command.save_game
		when 7 then TGM::Command.load_game
		when 8 then TGM::Command.wait
		end
	end
	
	def self.scene_play(x)
		$act_scene = x
		$scenes[x][1].each{|y|
		TGM.call_command(y)
		}
	end
	
	def self.main_scene
		TGM.scene_play(0)
	end
	
	def self.save_game(id)
		file = File.open("Save#{id}.sgm",'wb')
		$result = [$act_scene,$switches,$variables,$userdb]
		Marshal.dump($result, file)
		file.close
	end
	
	def self.load_game(id)
		file = File.open("Save#{id}.sgm",'rb')
		$result = Marshal.load(file)
		file.close
		$switches = $result[1]
		$variables = $result[2]
		$userdb = $result[3]
		TGM.scene_play($result[0])
	end
	
	def self.play(x=nil)
		if x == nil
			print "#{sel}Project to play : "
			project = gets.chomp!
			print "#{sel}Loading project..\n"
			file = File.open(project+'.xgm','rb')
			$xgm = Marshal.load(file)
			file.close
			$scenes = $xgm[4]
			$switches = $xgm[5]
			$variables = $xgm[6]
			$userdb = $xgm[7]
			$gamedb = $xgm[8]
			$project_name = $xgm[2]
			print "#{sel}Project #{$project_name} was loaded!\n#{sel}\n\n\n"
			TGM.scene_play(1)
		else
			project = x
			print "#{sel}Loading project..\n#{sel}\n\n"
			file = File.open(project+'.xgm','rb')
			$xgm = Marshal.load(file)
			file.close
			$scenes = $xgm[4]
			$switches = $xgm[5]
			$variables = $xgm[6]
			$userdb = $xgm[7]
			$gamedb = $xgm[8]
			$project_name = $xgm[2]
			print "#{sel}Project #{$project_name} was loaded!\n#{sel}\n\n\n"
			TGM.scene_play(1)
		end
	end
	
	def self.work_end
		print "\n#{sel}Press ENTER to close.\n#{sel}"
		$stdin.gets
		exit
	end
	
end

module TGM::Command
	
	def self.goto
		TGM.scene_play($args[0])
	end
	
	def self.msg
		print "#{$args[0]}\n"
	end
	
	def self.set_switch
		raise "Switches must be 0 or 1 value" if $args[0] > 1 or $args[0] < 0
		$switches[$args[0]] = $args[1]
	end
	
	def self.get_switch
		return $switches.at($args[0])
	end
	
	def self.set_variable
		$variables[$args[0]] = $args[1]
	end
	
	def self.get_variable
		return $variables.at($args[0])
	end
	
	def self.save_game
		print "#{sel}**Save Game\n#{sel}"
		print "Type the slot number. [0-100]\n"
		slot = gets.chomp!.to_i
		slot = 0 if slot < 0
		slot = 100 if slot > 100
		TGM.save_game(slot)
		print "\n#{sel}**Game saved succesfully!\n#{sel}\n"
	rescue
		print "\n#{sel}**Error while saving the game!\n#{sel}\n"
	end
	
	def self.load_game
		print "#{sel}**Load game\n#{sel}"
		print "Type the slot number. [0-100]\n"
		slot = gets.chomp!.to_i
		slot = 0 if slot < 0
		slot = 100 if slot > 100
		TGM.load_game(slot)
		print "\n#{sel}**Game loaded succesfully!\n#{sel}\n"
	rescue
		print "\n#{sel}**Error while loading the game!\n#{sel}\n"
	end
	
	def self.wait
		sleep($args[0])
	end
	
end

begin
	
	s = ARGV[0]
	if s == nil
		TGM.start
		TGM.play
	else
		TGM.start
		TGM.play(s)
	end
	TGM.work_end
	
rescue => e

	print "\nError occured : #{e}\nPress ENTER to exit."
	$stdin.gets
	exit
	
end
