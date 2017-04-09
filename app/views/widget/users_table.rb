class Widget::UsersTable < Qt::TableWidget

	attr_accessor :current_page
	attr_reader  :nbr_page

	def initialize headers = nil, page = 1
		super()
		@headers = headers || parent.selected_user.class.column_names || Utilisateur.column_names
		@current_page = page
		@headers.push "actions" if @headers.present?
		set_content
		set_style
		changed = SIGNAL("currentRowChanged(const QModelIndex &, const QModelIndex &)")
		selection_model.connect changed do |current, previous|
			select_user current.row, previous.row
		end
	end

	def set_content
		@columns = @headers.map { |header| header.parameterize.underscore }
		set_column_count @headers.size 
		setHorizontalHeaderLabels @headers
		horizontal_header.setResizeMode Qt::HeaderView::Fixed
		set_rows
	end

	def set_rows
		pagination = UserController.new.paginate @current_page
		@rows = pagination[:list]
		@total_count = pagination[:count]
		@nbr_page = pagination[:nbr_page]
		@current_page = @nbr_page if (@current_page > @nbr_page)
		@current_page = 1 if (@current_page < 1)
		set_row_count @rows.size
		populate
	end

	def set_buttons
		if @current_page == 1
			parent.first_button.hide
			parent.prev_button.hide
		else
			parent.first_button.show
			parent.prev_button.show
		end
		if @current_page == @nbr_page
			parent.last_button.hide
			parent.next_button.hide
		else
			parent.last_button.show
			parent.next_button.show
		end	
	end

	def set_page page
		@current_page = page unless page > @nbr_page
		empty_list
		set_rows
		select_user 0
		set_buttons
	end

	def set_style
		verticalHeader.setVisible false
		verticalHeader.width = 0
		setSelectionBehavior Qt::AbstractItemView::SelectRows
		setSelectionMode Qt::AbstractItemView::SingleSelection
		setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff)
		setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff)
		compute_size
	end

	def populate 
		@rows.each_with_index do |row, row_index|
			@columns.each_with_index do |column, col_index|
				populate_index column, row, row_index, col_index
			end	
		end
		add_button 0
	end

	def empty_list
		set_row_count 0
	end

	def reload_list
		empty_list
		@rows.reload
		set_rows
		compute_size
		parent.setFixedSize(620, height + 310)
		set_buttons
		select_user 0
	end

	def populate_index column, row, row_index, col_index
		if column != "actions"
			item = Qt::TableWidgetItem.new(row.send(column).to_s)
			#item.setFlags(Qt::ItemIsEnabled)
			set_item(row_index, col_index, item)
		end	
	end

	def add_button index
		edit_button = Qt::PushButton.new "modifier".upcase
		setCellWidget(index, last_column, edit_button)
		edit_button.connect SIGNAL :clicked do 
			parent.display_edit_page
		end
	end

	def remove_button index
		remove_cell_widget index, last_column
	end

	def compute_size
		#resizeColumnsToContents
		#resizeRowsToContents
		setFixedSize [500, horizontalHeader.length + verticalHeader.width].max, [32 * (row_count) + horizontalHeader.height , $gsb_session[:per_page] * 40].min
	end

	def mousePressEvent(event)
	    if event.button() == Qt::RightButton
			close_user_panel unless row_count == 0
	   	elsif event.button() == Qt::LeftButton
	   		select_action event
	   		display_data unless row_count == 0
		end
  	end

  	def select_action event
  		index = indexAt(event.pos).row
   		select_row index if index > -1
  	end

  	def select_user index, prev = -1
  		remove_button prev unless prev == index or prev == -1
  		select_column last_column
  		add_button index
   		parent.selected_user = @rows[index] 
  	end
	
	def display_data
		if parent.present?
			parent.user_display.populate parent.selected_user
			#parent.setFixedSize width + parent.panel_width + 20, [height + 100, 400].max
			if parent.user_panel.present?
				parent.user_panel.set_window_title "GSB : Consulter profil #{parent.selected_user.nom_complet}"
				parent.user_panel.show
				parent.user_panel.raise
				parent.load_file
			end
		end
	end

  	def close_user_panel
  		parent.user_panel.resize 0, parent.user_panel.height
		#parent.setFixedSize width + 20, [height + 101, 580].max
		parent.user_panel.hide
  	end
	
	def remove_row index
		super
		@rows.reload
	end

	def last_column
		column_count - 1
	end

	def wheelEvent event 
		return false
	end
end