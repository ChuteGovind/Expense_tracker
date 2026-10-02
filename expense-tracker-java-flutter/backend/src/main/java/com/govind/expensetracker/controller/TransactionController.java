package com.govind.expensetracker.controller;
import com.govind.expensetracker.dto.*; import com.govind.expensetracker.entity.TransactionType; import com.govind.expensetracker.service.TransactionService; import jakarta.validation.Valid; import org.springframework.http.HttpStatus; import org.springframework.web.bind.annotation.*; import java.time.LocalDate; import java.util.List;
@RestController @RequestMapping("/api/v1/transactions") public class TransactionController {
 private final TransactionService service; public TransactionController(TransactionService service){this.service=service;}
 @GetMapping("/meta/categories") public List<String> categories(){return service.categories();}
 @GetMapping public List<TransactionResponse> all(@RequestParam(required=false) TransactionType type,@RequestParam(required=false) String category,@RequestParam(required=false) LocalDate from,@RequestParam(required=false) LocalDate to){return service.findAll(type,category,from,to);}
 @GetMapping("/{id}") public TransactionResponse one(@PathVariable Long id){return service.get(id);}
 @PostMapping @ResponseStatus(HttpStatus.CREATED) public TransactionResponse create(@Valid @RequestBody TransactionRequest r){return service.create(r);}
 @PutMapping("/{id}") public TransactionResponse update(@PathVariable Long id,@Valid @RequestBody TransactionRequest r){return service.update(id,r);}
 @DeleteMapping("/{id}") @ResponseStatus(HttpStatus.NO_CONTENT) public void delete(@PathVariable Long id){service.delete(id);}
}
