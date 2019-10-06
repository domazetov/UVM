`ifndef eq_AXIS_BASE_SEQ_SV
`define eq_AXIS_BASE_SEQ_SV

class eq_axis_base_seq extends uvm_sequence#(axis_frame);

   `uvm_object_utils(eq_axis_base_seq)

   // PARAMETERS
   localparam bit[9:0] sv_array[0:9] = {10'd361, 10'd267, 10'd581, 10'd632, 10'd480, 10'd513, 10'd376, 10'd432, 10'd751, 10'd683};
   localparam bit[9:0] IMG_LEN = 10'd784; 
   `uvm_declare_p_sequencer(axis_sequencer)

   string y_dir = "..\/..\/SVM_data\/bin_data\/y";
   string b_dir = "..\/..\/SVM_data\/bin_data\/b";
   string lt_dir = "..\/..\/SVM_data\/bin_data\/lt";
   string sv_dir = "..\/..\/SVM_data\/bin_data\/sv";

   logic[15 : 0] yQ[$];
   logic[15 : 0] bQ[10];
   logic[15 : 0] ltQ[10][$];
   logic[15 : 0] svQ[10][$];

   logic[15 : 0] tmp;
   int i=0;
   int num=0;
   int fd=0;
   string s="";

   int image=0;
   int core=0;
   int sv=0;

   function new(string name = "eq_axis_base_seq");
      super.new(name);
      extract_data();
   endfunction

   // objections are raised in pre_body
   virtual task pre_body();
      uvm_phase phase = get_starting_phase();
      if (phase != null)
          phase.raise_objection(this, {"Running sequence '", get_full_name(), "'"});
   endtask : pre_body 

   // objections are dropped in post_body
   virtual task post_body();
      uvm_phase phase = get_starting_phase();
      if (phase != null)
          phase.drop_objection(this, {"Completed sequence '", get_full_name(), "'"});
   endtask : post_body

   function void extract_data();
      //CLEAR QUEUES, EXTRACT DATA FROM FILES                                       *****
      while(yQ.size()!=0)
      yQ.delete(0);

      for(int c=0; c<10; c++)
      begin
         bQ[c]=0;
         while(ltQ[c].size()!=0)
            ltQ[c].delete(0);
         while(ltQ[c].size()!=0)   
            svQ[c].delete(0);   
      end

      //EXTRACTING TEST IMAGE [y]
      fd = ($fopen({y_dir,"/\y_bin.txt"}, "r"));
      if(fd)
      begin
         `uvm_info(get_name(),$sformatf("y_bin opened successfuly"),UVM_HIGH);

         while(!$feof(fd))
         begin
            if(i == 783) 
            begin
               $fscanf(fd ,"%b\n",tmp);
               yQ.push_back(tmp);
               num++;
               i = 0;             
            end  
            else 
            begin
               $fscanf(fd ,"%b",tmp);
               yQ.push_back(tmp);
               i++;
            end
            
         end
         `uvm_info(get_name(),$sformatf("Num of images in queue is: %d",num),UVM_HIGH);
      end
      else
        `uvm_info(get_name(),$sformatf("Error opening y_bin file"),UVM_HIGH);
        num=0;
      $fclose(fd);

      //EXTRACTING SUPPORT VECTORS [sv]
      for (int x=0; x<10; x++)
      begin
         s.itoa(x);
         fd = ($fopen({sv_dir,"/\sv_bin",s,".txt"}, "r"));
         if(fd)
         begin
            `uvm_info(get_name(),$sformatf("sv_bin%d opened successfuly",x),UVM_HIGH);
            while(!$feof(fd))
            begin
               if(i == 783) 
               begin
                  $fscanf(fd ,"%b\n",tmp);
                  svQ[x].push_back(tmp);
                  num++;
                  i = 0;             
               end  
               else 
               begin
                  $fscanf(fd ,"%b",tmp);
                  svQ[x].push_back(tmp);
                  i++;
               end
               
            end
            `uvm_info(get_name(),$sformatf("Num of support vectors for core %d in queue is: %d",x,num),UVM_HIGH);
         end
         else
           `uvm_info(get_name(),$sformatf("Error opening %d. sv_bin file",x),UVM_HIGH);
           num=0;
         $fclose(fd);
      end

      //EXTRACTING LAMBDAS [lt] 
      for (int x=0; x<10; x++)
      begin
         s.itoa(x);
         fd = ($fopen({lt_dir,"/\lt_bin",s,".txt"}, "r"));
         if(fd)
         begin
            `uvm_info(get_name(),$sformatf("lt_bin%d opened successfuly",x),UVM_HIGH);
            while(!$feof(fd))
            begin
                  $fscanf(fd ,"%b\n",tmp);
                  ltQ[x].push_back(tmp);
                  num++;
               
            end
            `uvm_info(get_name(),$sformatf("Num of lambdas for core %d in queue is: %d",x,num),UVM_HIGH);

         end
         
         else
           `uvm_info(get_name(),$sformatf("Error opening %d. lt_bin file",x),UVM_HIGH);
           num=0;
         $fclose(fd);
      end

      //EXTRACTING BIASES [b]
      for (int x=0; x<10; x++)
      begin
         s.itoa(x);
         fd = ($fopen({b_dir,"/\b_bin",s,".txt"}, "r"));
         if(fd)
         begin
            `uvm_info(get_name(),$sformatf("b_bin%d opened successfuly",x),UVM_HIGH);
            while(!$feof(fd))
            begin
                  $fscanf(fd ,"%b\n",tmp);
                  bQ[x]=tmp;
            end
         end
         else
           `uvm_info(get_name(),$sformatf("Error opening %d. b_bin file",x),UVM_HIGH);
           num=0;
         $fclose(fd);
      end
    endfunction

endclass : eq_axis_base_seq

`endif

