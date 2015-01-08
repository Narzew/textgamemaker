$tgm_version = 0.01
$tgm_reldate = "07.04.2012"

require 'fileutils'

def sel
	return "============================================================\n"
end

module TGM

	class Command
	
		def initialize(id, cat, cid, args)
			@command_id = id
			@command_category = cat
			@command_cid = cid
			@command_args = args
		end
		
		def get_id
			return @command_id
		end
		
		def get_category
			return @command_category
		end
		
		def get_cid
			return @command_cid
		end
		
		def get_args
			return @command_args
		end
		
		def to_text
			return "#{@command_id}: cat_to_text(@command_category):cid_to_text(@command_category,@command_cid) args_to_text(@command_args)\n"
		end
		
		def eval
			TGM.eval_command(@command_category,@command_cid,@command_args)
		end
		
	end
	
end

module TGM

	class Scene
	
		def initialize(id)
			@scene_id = id
			@scene_name = ""
			@scene_commands = []
		end
		
		def get_name
			return @scene_name
		end
		
		def set_name(x)
			@scene_name = x
		end
		
		def add_command_to_scene(command)
			@scene_commands << command
		end
		
		def show_scene_commands
			@scene_commands.each{|x|
				print x.to_text
			}
		end
		
		def remove_command_from_scene(id)
			@scene_commands.each{|x|
				@scene_commands[x] = nil if x.get_id == id
				break
			}
		end
		
	end
	
end

module TGM

	module Function
	
		def intialize(cat,id,name,code)
			@function_category = cat
			@function_id = id
			@function_name = name
			@function_code = code
		end
		
		def self.get_category
			return @function_category
		end
		
		def self.get_id
			return @function_id
		end
		
		def self.get_name
			return @function_name
		end
		
		def self.get_code
			return @function_code
		end
		
		def self.eval(args)
			$function_args = args
			eval(@function_code)
		end
		
	end
	
end

module TGM

	class Project
	
		def initialize(name, filename, author)
			@project_name = name
			@project_filename = filename
			@project_author = author
			@project_scenes = []
			@project_version = 1.00
			@project_builds = 0
			@project_magic = rand(0xFFFFFFFF)
		end
		
		def self.get_name
			return @project_name
		end
		
		def self.set_name(name)
			@project_name = name
		end
		
		def self.get_filename
			return @project_filename
		end
		
		def self.set_filename(filename)
			@project_filename = filename
		end
		
		def self.get_author
			return @project_author
		end
		
		def self.set_author(author)
			@project_author = author
		end
		
		def self.get_version
			return @project_version
		end
		
		def self.set_version(version)
			@version = version
		end
		
		def self.build
			@project_magic = rand(0xFFFFFFFF)
			@project_builds += 1
			$result = Marshal.dump(Zlib::Deflate.deflate(Marshal.dump([0,"TGM 1.00",[@project_name,@project_author,@project_version,@project_magic,@project_builds],[Marshal.dump(@scenes)]])))
			file = File.open(@project_filename, 'rb')
			file.write($result)
			file.close
			print "Kompilacja pomyślna."
		rescue => e
			TGM.error("COMPILATION FAIL")
		end
	
	end

end

module TGM

	def self.print_header
		print "Text Game Maker\nv1.00\nby Narzew\nAll rights reserved.\n\n\n"
	end
	
	def self.print_footer
		print "Dziękujemy za użycie Text Game Makera\n"
		exit
	end

	def self.error(type)
		case type
		when "BAD CHOICE"
			print "Zły wybór!\n"
			exit
		when "COMPILATION FAIL"
			print "Kompilacja nieudana!\n"
			exit
		when "UNKNOWN ERROR"
			print "Nieznany błąd!\n"
			exit
		else
			print type
			exit
		end
	end
	
	def self.exit
		print "Dziękujemy za użycie programu Text Game Maker\n"
		exit
	end
	
	def self.main_menu
		print "0 - Nowy projekt\n"
		print "1 - Otwórz projekt\n"
		print "2 - Wyjdź z programu\n"
		mode = $stdin.gets.chomp!.to_i
		case mode
		when 0 then TGM.new_project
		when 1 then TGM.load_project
		when 2 then TGM.exit
		else
			TGM.error("BAD CHOICE")
		end
	end
	
	def self.new_project
		print "Podaj nazwę projektu: "
		name = $stdin.gets.chomp!
		print "Podaj śćieżkę projektu: "
		path = $stdin.gets.chomp!
		print "Podaj autora projektu: "
		author = $stdin.gets.chomp!
		$project = TGM::Project.new(name,path,author)
		$project.build
	end
	
end

begin
	TGM.print_header
	TGM.main_menu
	TGM.print_footer
rescue => e
	TGM.error(e)
end
