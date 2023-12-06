`include "datapath_NREG.v"
`timescale 1ns/1ps

module datapathTB;
  parameter N = 16;
  parameter pipe = 0;
  reg signed [N-1:0] A, B;
  reg [2:0] opcode;
  wire signed [N-1:0] Y;
  wire co;
  reg clk;

  datapath myDatapath (.A(A), .B(B), .opcode(opcode), .Y(Y), .co(co), .clk(clk), .pipe(pipe));

  initial begin
    int file;
    
    clk = 0;
    
    file = $fopen("circuit_input.txt", "r");

    if (file == 0)
      begin
        $display("File non trovato");
        $finish;
      end

    while (!$feof(file)) 
      begin
        $fscanf(file, "%d %d %b", A, B, opcode);

        // Imposta pipe a 0
        pipe = 0;
        #10; // Aggiungi un ritardo per garantire che l'assegnazione di pipe abbia effetto

        $display("[time: %0dns, sum] A:%0d, B:%0d, Y:%0d, co:%b", $time, A, B, Y, co);

        // Imposta pipe a 1
        pipe = 1;
        #10; // Aggiungi un ritardo per garantire che l'assegnazione di pipe abbia effetto

        $display("[time: %0dns, sum] A:%0d, B:%0d, Y:%0d, co:%b", $time, A, B, Y, co);
    
      end

    $fclose(file);
    $finish;
    
    // Simulazione per diversi cicli di clock
    #50;
    repeat (10) begin
      clk = ~clk;

      // Visualizza i risultati sul fronte di salita del clock
      @(posedge clk) $display("[time: %0dns, result] A:%0d, B:%0d, Y:%0d, co:%b", $time, A, B, Y, co);
    end

    #10;
    
  end
  
endmodule
