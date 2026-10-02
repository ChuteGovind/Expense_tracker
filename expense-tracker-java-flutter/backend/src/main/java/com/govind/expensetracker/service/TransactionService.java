package com.govind.expensetracker.service;
import com.govind.expensetracker.dto.*; import com.govind.expensetracker.entity.*; import com.govind.expensetracker.repository.TransactionRepository;
import org.springframework.http.HttpStatus; import org.springframework.stereotype.Service; import org.springframework.web.server.ResponseStatusException;
import java.math.*; import java.time.*; import java.util.*; import java.util.stream.Collectors;
@Service public class TransactionService {
 private final TransactionRepository repo; public TransactionService(TransactionRepository repo){this.repo=repo;}
 public List<TransactionResponse> findAll(TransactionType type,String category,LocalDate from,LocalDate to){
  List<Transaction> xs=(from!=null&&to!=null)?repo.findByTransactionDateBetweenOrderByTransactionDateDescIdDesc(from,to):(type!=null?repo.findByTypeOrderByTransactionDateDescIdDesc(type):repo.findAllByOrderByTransactionDateDescIdDesc());
  return xs.stream().filter(t->type==null||t.getType()==type).filter(t->category==null||category.isBlank()||t.getCategory().equalsIgnoreCase(category)).map(this::response).toList();
 }
 public TransactionResponse get(Long id){return response(entity(id));}
 public TransactionResponse create(TransactionRequest r){Transaction t=new Transaction();apply(t,r);return response(repo.save(t));}
 public TransactionResponse update(Long id,TransactionRequest r){Transaction t=entity(id);apply(t,r);return response(repo.save(t));}
 public void delete(Long id){if(!repo.existsById(id))throw new ResponseStatusException(HttpStatus.NOT_FOUND,"Transaction not found");repo.deleteById(id);}
 public List<String> categories(){return repo.findAll().stream().map(Transaction::getCategory).filter(Objects::nonNull).distinct().sorted().toList();}
 public DashboardResponse dashboard(YearMonth month){
  List<Transaction> current=repo.findByTransactionDateBetweenOrderByTransactionDateDescIdDesc(month.atDay(1),month.atEndOfMonth());
  BigDecimal income=sum(current,TransactionType.INCOME), expense=sum(current,TransactionType.EXPENSE);
  Map<String,BigDecimal> map=current.stream().filter(t->t.getType()==TransactionType.EXPENSE).collect(Collectors.groupingBy(Transaction::getCategory,Collectors.reducing(BigDecimal.ZERO,Transaction::getAmount,BigDecimal::add)));
  List<CategorySummary> cats=map.entrySet().stream().sorted(Map.Entry.<String,BigDecimal>comparingByValue().reversed()).map(e->new CategorySummary(e.getKey(),money(e.getValue()),expense.signum()==0?0:e.getValue().multiply(BigDecimal.valueOf(100)).divide(expense,2,RoundingMode.HALF_UP).doubleValue())).toList();
  List<MonthlySummary> trend=new ArrayList<>(); for(int i=5;i>=0;i--){YearMonth ym=month.minusMonths(i);List<Transaction> xs=repo.findByTransactionDateBetweenOrderByTransactionDateDescIdDesc(ym.atDay(1),ym.atEndOfMonth());trend.add(new MonthlySummary(ym.toString(),money(sum(xs,TransactionType.INCOME)),money(sum(xs,TransactionType.EXPENSE))));}
  return new DashboardResponse(money(income),money(expense),money(income.subtract(expense)),cats,trend);
 }
 private BigDecimal sum(List<Transaction> xs,TransactionType type){return xs.stream().filter(t->t.getType()==type).map(Transaction::getAmount).reduce(BigDecimal.ZERO,BigDecimal::add);}
 private BigDecimal money(BigDecimal n){return n.setScale(2,RoundingMode.HALF_UP);}
 private void apply(Transaction t,TransactionRequest r){t.setType(r.type());t.setCategory(r.category().trim());t.setTitle(r.title().trim());t.setAmount(r.amount().setScale(2,RoundingMode.HALF_UP));t.setTransactionDate(r.transactionDate());t.setNote(r.note()==null?null:r.note().trim());}
 private Transaction entity(Long id){return repo.findById(id).orElseThrow(()->new ResponseStatusException(HttpStatus.NOT_FOUND,"Transaction not found"));}
 private TransactionResponse response(Transaction t){return new TransactionResponse(t.getId(),t.getType(),t.getCategory(),t.getTitle(),money(t.getAmount()),t.getTransactionDate(),t.getNote());}
}
